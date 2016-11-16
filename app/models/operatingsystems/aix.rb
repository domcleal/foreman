class AIX < Operatingsystem
  PXEFILES = {:kernel => "powerpc", :initrd => "initrd"}

  class << self
    delegate :model_name, :to => :superclass
  end

  def pxe_type
    "nim"
  end

  def pxedir
    "boot/$arch/loader"
  end

  def url_for_boot(file)
    pxedir + "/" + PXEFILES[file]
  end

  def display_family
    "AIX"
  end
end
