class AppointmentStatus {
  static const requested = "requested";
  //status is active means appointment is ongoing and active
  static const active = "active";
  //in case appointment is not accepted
  static const pending = "pending";
  //in case appointment is deleted || cancelled
  static const cancelled = "cancelled";
  //appointment has successfully completed
  static const completed = "completed";
  //  customer didn't show up
  static const noShow = "noShow";
  //  customer's appointment is doing on(or happening currently)
  static const checkedIn = "checkedIn";

}

///contains all the actions possible on an appointment
class AppointmentUpdates {
  //created
  static const createdByCustomer = "createdByCustomer";
  static const createdBySalon = "createdBySalon";
  //update
  static const changedByCustomer = "changedByCustomer";
  static const changedBySalon = "changedBySalon";
  //cancelled
  static const cancelledByCustomer = "cancelledByCustomer";
  static const cancelledBySalon = "cancelledBySalon";

  //request
  static const approvedBySalon = "approvedBySalon";


}


class AppointmentType{
  static const reservation = "reservation";
  static const blockTime = "blockTime";


}

/// appointment is created by salon or by customer
class CreatedBy{
  static const salon = "salon";
  static const customer = "customer";
}