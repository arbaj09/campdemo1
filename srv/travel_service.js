const cds = require ('@sap/cds'); 

class TravelService extends cds.ApplicationService {
init() {

  

  //
  // Action Implementations...
  //


  this.on ('acceptTravel', req => UPDATE (req.subject) .with ({TravelStatus_code:'A'}))
  this.on ('rejectTravel', req => UPDATE (req.subject) .with ({TravelStatus_code:'X'}))
 


  // Add base class's handlers. Handlers registered above go first.
  return super.init()

}}




module.exports = {TravelService}
