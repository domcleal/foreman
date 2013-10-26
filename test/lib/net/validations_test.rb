require 'test_helper'
require 'net'

class ValidationsTest < ActiveSupport::TestCase
  include Net::Validations

  test "mac address should be valid" do
    assert_nothing_raised Net::Validations::Error do
      validate_mac "aa:bb:cc:dd:ee:ff"
    end
  end

  test "mac should be invalid" do
    assert_raise Net::Validations::Error do
      validate_mac "abc123asdas"
    end
  end

  describe "mac normalization" do

    let(:mac) { "aa:bb:cc:dd:ee:ff" }

    test "should normalize dash separated format" do
      Net::Validations.normalize_mac("aa-bb-cc-dd-ee-ff").must_equal(mac)
    end

    test "should normalize condensed format" do
      Net::Validations.normalize_mac("aabbccddeeff").must_equal(mac)
    end

    test "should keep colon separated format" do
      Net::Validations.normalize_mac("aa:bb:cc:dd:ee:ff").must_equal(mac)
    end

  end

  test "IPv4 address should be valid" do
    assert validate_ip("127.0.0.1")
  end

  test "IPv4 address should be invalid" do
    refute validate_ip("127.0.0.300")
  end

  test "return IP when IPv4 address is valid" do
    assert_nothing_raised Net::Validations::Error do
      assert "127.0.0.1", validate_ip!("127.0.0.1")
    end
  end

  test "raise error when IPv4 address is invalid" do
    assert_raise Net::Validations::Error do
      validate_ip! "127.0.0.1.2"
    end
  end

  test "IPv6 address should be valid" do
    assert validate_ip6("::1")
  end

  test "IPv6 address should be invalid" do
    refute validate_ip6("2001:db8::0::1")
  end

  test "return IP when IPv6 address is valid" do
    assert_nothing_raised Net::Validations::Error do
      assert "::1", validate_ip6!("::1")
    end
  end

  test "raise error when IPv6 address is invalid" do
    assert_raise Net::Validations::Error do
      validate_ip6! "2001:db8::0::1"
    end
  end

  test "should normalize IPv4 address" do
    assert_equal "127.0.0.1", Net::Validations.normalize_ip("127.000.0.1")
  end

  test "should ignore invalid data when normalizing IPv4 address" do
    assert_equal "xyz.1.2.3", Net::Validations.normalize_ip("xyz.1.2.3")
  end

  test "should normalize IPv6 address" do
    assert_equal "2001:db8::1", Net::Validations.normalize_ip6("2001:db8:0000::1")
  end

  test "should ignore invalid data when normalizing IPv6 address" do
    assert_equal "2001:db8::0000::1", Net::Validations.normalize_ip6("2001:db8::0000::1")
  end
end
