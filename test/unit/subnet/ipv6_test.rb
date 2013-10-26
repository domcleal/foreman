require 'test_helper'

class Ipv6Test < ActiveSupport::TestCase
  def setup
    User.current = User.find_by_login "admin"
  end

  test "should have a network" do
    @subnet = FactoryGirl.build(:subnet_ipv6)
    old_network = @subnet.network
    @subnet.network = nil
    refute @subnet.valid?

    @subnet.network = old_network
    assert @subnet.valid?
  end

  test "should have a mask" do
    @subnet = FactoryGirl.build(:subnet_ipv6)
    old_mask = @subnet.mask
    @subnet.mask = nil
    refute @subnet.valid?

    @subnet.mask = old_mask
    assert @subnet.valid?
  end

  test "network should have ip format" do
    @subnet = FactoryGirl.build(:subnet_ipv6, :network => "asf:fwe6::we6s:q1")
    refute @subnet.valid?
  end

  test "mask should have ip format" do
    @subnet = FactoryGirl.build(:subnet_ipv6, :mask => "asf:fwe6::we6s:q1")
    refute @subnet.valid?
  end

  test "network should be unique" do
    first = FactoryGirl.create(:subnet_ipv6)
    subnet = FactoryGirl.build(:subnet_ipv6, :network => first.network)
    refute subnet.valid?
  end

  test "network should be unique, after normalization" do
    first = FactoryGirl.create(:subnet_ipv6, :network => '2001:db8::')
    subnet = FactoryGirl.build(:subnet_ipv6, :network => '2001:db8:0000::')
    refute subnet.valid?
  end

  test "the name should be unique in the domain scope" do
    first = FactoryGirl.create(:subnet_ipv6, :with_domains)
    subnet = FactoryGirl.build(:subnet_ipv6, :name => first.name, :domains => first.domains)
    refute subnet.valid?
  end

  test "duplicate names are permitted outside of domain scope" do
    first = FactoryGirl.create(:subnet_ipv6)
    subnet = FactoryGirl.build(:subnet_ipv6, :name => first.name)
    assert subnet.valid?
  end

  test "when to_label is applied should show the network and mask" do
    subnet = FactoryGirl.build(:subnet_ipv6, :network => '2001:db8::')
    assert_equal "2001:db8::/64", subnet.to_label
  end

  test "should find the subnet by ip" do
    subnet = FactoryGirl.create(:subnet_ipv6)
    assert_equal subnet, Subnet::Ipv6.subnet_for(get_ip(subnet, 10))
  end

  test "user with create permissions should be able to create" do
    setup_user "create"
    record = FactoryGirl.build(:subnet_ipv6)
    assert record.save
    assert !record.new_record?
  end

  test "user with view permissions should not be able to create" do
    setup_user "view"
    record = FactoryGirl.build(:subnet_ipv6)
    assert record.valid?
    refute record.save
    assert record.new_record?
  end

  test "user with destroy permissions should be able to destroy" do
    record = FactoryGirl.create(:subnet_ipv6)
    setup_user "destroy"
    as_admin do
      record.domains.destroy_all
      record.hosts.clear
      record.interfaces.clear
    end
    assert record.destroy
    assert record.frozen?
  end

  test "user with edit permissions should not be able to destroy" do
    record = FactoryGirl.create(:subnet_ipv6)
    setup_user "edit"
    refute record.destroy
    refute record.frozen?
  end

  test "user with edit permissions should be able to edit" do
    record = FactoryGirl.create(:subnet_ipv6)
    setup_user "edit"
    record.name = "renamed"
    assert record.save
  end

  test "user with destroy permissions should not be able to edit" do
    record = FactoryGirl.create(:subnet_ipv6)
    setup_user "destroy"
    record.name = "renamed"
    as_admin do
      record.domains = [domains(:unuseddomain)]
    end
    refute record.save
    assert record.valid?
  end

  test "from cant be bigger than to range" do
    s = FactoryGirl.build(:subnet_ipv6)
    s.to = get_ip(s, 10)
    s.from = get_ip(s, 17)
    refute s.valid?
  end

  test "should be able to save ranges" do
    s = FactoryGirl.build(:subnet_ipv6)
    s.from = get_ip(s, 10)
    s.to = get_ip(s, 17)
    assert s.save
  end

  test "should not be able to save ranges if they dont belong to the subnet" do
    s = FactoryGirl.build(:subnet_ipv6, :network => '2001:db8:1::')
    s.from = '2001:db8:2::1'
    s.to = '2001:db8:2::2'
    refute s.valid?
  end

  test "should not be able to save ranges if one of them is missing" do
    s = FactoryGirl.build(:subnet_ipv6)
    s.from = get_ip(s, 10)
    refute s.valid?
    s.to = get_ip(s, 17)
    assert s.valid?
  end

  test "should not be able to save ranges if one of them is invalid" do
    s = FactoryGirl.build(:subnet_ipv6)
    s.from = get_ip(s, 10).gsub(/:[^:]*:/, ':xyz:')
    s.to = get_ip(s, 17)
    refute s.valid?
  end

  test "should strip whitespace before save" do
    s = FactoryGirl.build(:subnet_ipv6, :network => '2001:db8::')
    s.network = " #{s.network}   "
    s.mask = " #{s.mask}   "
    s.gateway = " 2001:db8::1   "
    s.dns_primary = " 2001:db8::2   "
    s.dns_secondary = " 2001:db8::3   "
    assert s.save
    assert_equal '2001:db8::', s.network
    assert_equal 'ffff:ffff:ffff:ffff::', s.mask
    assert_equal '2001:db8::1', s.gateway
    assert_equal '2001:db8::2', s.dns_primary
    assert_equal '2001:db8::3', s.dns_secondary
  end

  test "should not allow an address greater than 45 characters" do
    s = FactoryGirl.build(:subnet_ipv6, :mask => 9.times.map { 'abcd' }.join(':'))
    refute s.valid?
    assert_match /is invalid/, s.errors.full_messages.join("\n")
  end

  test "trailing colons in addresses are invalid" do
    refute FactoryGirl.build(:subnet_ipv6, :network => '2001:db8::1:').valid?
  end

  test "more than 4 chars in a block is invalid" do
    refute FactoryGirl.build(:subnet_ipv6, :network => '2001:db8:abcde::1').valid?
  end

  # test module StripWhitespace which strips leading and trailing whitespace on :name field
  test "should strip whitespace on name" do
    s = FactoryGirl.build(:subnet_ipv6, :name => '    ABC Network     ')
    assert s.save!
    assert_equal "ABC Network", s.name
  end

  private

  def setup_user operation
    @one = users(:one)
    as_admin do
      role = Role.find_or_create_by_name :name => "#{operation}_subnets"
      role.permissions = ["#{operation}_subnets".to_sym]
      @one.roles = [role]
      @one.save!
    end
    User.current = @one
  end

  def get_ip(subnet, i = 1)
    IPAddr.new(subnet.ipaddr.to_i + i, subnet.family).to_s
  end
end
