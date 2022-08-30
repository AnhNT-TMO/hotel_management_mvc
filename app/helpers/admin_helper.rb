module AdminHelper
  def bill_status_options
    statuses = Bill.statuses.to_a
    statuses.unshift ["All", ""]
    statuses
  end

  def bill_status_edit_options bill
    if bill.confirm?
      Bill.statuses.slice(:confirm, :paid).keys.to_a
    else
      Bill.statuses.keys.to_a
    end
  end

  def room_types_options
    types = Room.types.to_a
    types.unshift ["All", ""]
    types
  end
end
