module IPA
  module Common
    @@IPAlist_element = {
        :hostgroup    => 'cn',
        :group        => 'cn',
        :sudocmd      => 'sudocmd',
        :sudorule     => 'cn',
        :sudocmgroup  => 'cn',
        :hbacrule     => 'cn',
        :hbacsvc      => 'cn',
        :hbacsvcgroup => 'cn',
    }

    def initialize(parent)
      @parent   = parent
      @ipaclass = self.class.name.downcase.sub(/^ipa/,'')
    end

    def post(*args)
      @parent.post(*args)
    end

    def list_element
      @@IPAlist_element[@ipaclass.to_sym]
    end

    def list
      results = []
      res = post("#{@ipaclass}_find", [[nil],{"pkey_only" => true,"sizelimit" => 0}] )
      res['result']['result'].each do |group|
        results << group[self.list_element].first
      end
      results
    end

    def show(target)
      res = post("#{@ipaclass}_show", [[target],{}] )
      res['result']['result']
    end

    def add(target,desc=nil)
      desc = target if desc.nil?
      post("#{@ipaclass}_add", [[target],{"description" => desc}] )
    end

    def del(target)
      post("#{@ipaclass}_del", [[target],{}] )
    end
  end
end