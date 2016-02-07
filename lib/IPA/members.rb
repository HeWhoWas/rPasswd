module IPA
  module Members
    @@IPAmember_element = {
        :hostgroup    => :host,
        :group        => :user,
        :sudocmdgroup => :sudocmd,
        :hbacsvcgroup => :hbacsvc,
    }

    def member_element
      @@IPAmember_element[@ipaclass.to_sym]
    end

    [:add, :remove ].each do |action|
      meth = "#{action}_member"
      define_method(meth) do |target,members|
        members = Array(members)
        post("#{@ipaclass}_#{__method__}", [[target],{"all" => true, self.member_element => members}] )
      end
    end

    def list_member(target)
      res = show(target)
      res["member_#{self.member_element}"]
    end
  end
end