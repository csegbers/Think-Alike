
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});
Parse.Cloud.define("hello2", function(request, response) {
  response.success("Hello2 world!");
});
Parse.Cloud.define("goodbye", function(request, response) {
  response.success("goodbye world!");
});
Parse.Cloud.define("hellogoodbye", function(request, response) {
  response.success("hellogoodbye world!");
   
});

Parse.Cloud.define("getvehsforpolicy", function(request, response) {
        var _ = require('underscore');
        //-----------------------------------
        // Create a query for Policy
        //-----------------------------------
        var Policy = Parse.Object.extend("Policy");
        var query = new Parse.Query(Policy);
  
        //-----------------------------------
        // Quesy withing X miles
        //-----------------------------------
        query.equalTo("policyNumber",request.params.policyNumber);
        query.descending("effDate");
 
        var newresultsJson = [];
        var outputRecs = [];
        var policyVehs = [];
 
        //-----------------------------------
        // Quesy against policy table
        //-----------------------------------     
        query.find().then(function(results) 
          {
                var promise = Parse.Promise.as();
                _.each(results, function(resultObj) 
                { 
     
                    promise = promise.then(function() 
                      {
                          outputRecs = [];
                          policyVehs = (resultObj.toJSON());
                          policyVehs["policyVehs"] =[ ];
            
                          var PolicyVehs  = Parse.Object.extend("PolicyVehs");
                          var querypolicyvehs = new Parse.Query(PolicyVehs);
                          querypolicyvehs.equalTo("policyNumber", resultObj.get("policyNumber"));
                          querypolicyvehs.equalTo("policyMod", resultObj.get("policyMod"));
                          querypolicyvehs.descending("vehYear");

                          //-----------------------------------
                          // Quesy against doc table
                          //----------------------------------- 
                          var subPromise = Parse.Promise.as();
                          return querypolicyvehs.find().then(
                                       function(thePolicyVehs)
                                             {
                                               policyVehs["policyVehs"].push(thePolicyVehs);
                                             }
                                          ).then(function() { outputRecs.push(policyVehs); });   // for each term in Policy table
                                        
                       }).then(function() { newresultsJson.push(outputRecs); });  // _promise
                       
                 });   // _each loop for each policy in Relationship table
                 return promise;

         }, function (error) {response.error("Error "+error.message); // everything is done and error on the first query find
         }).then(function() {response.success(newresultsJson);  });   // everything is done and good on the first query find
 
       
  
                    
});    // the function

Parse.Cloud.define("getvehsforpolicyold", function(request, response) {
 
        //-----------------------------------
        // Create a query for Policy
        //-----------------------------------
        var PolicyVehs = Parse.Object.extend("PolicyVehs");
        var query = new Parse.Query(PolicyVehs);
  
        //-----------------------------------
        // Query - just need policy
        //-----------------------------------
        query.equalTo("policyNumber",request.params.policyNumber);
        query.equalTo("policyMod",request.params.policyMod);


        query.find( {
         success: function(results) {
            // The object was retrieved successfully.
            response.success(results);
          },
         error: function(object, error) {
           // The object was not retrieved successfully.
           // error is a Parse.Error with an error code and description.
         }
       });
    
                    
});    // the function

Parse.Cloud.define("getdocsforpolicy", function(request, response) {
        var _ = require('underscore');
        //-----------------------------------
        // Create a query for Policy
        //-----------------------------------
        var Policy = Parse.Object.extend("Policy");
        var query = new Parse.Query(Policy);
  
        //-----------------------------------
        // Quesy withing X miles
        //-----------------------------------
        query.equalTo("policyNumber",request.params.policyNumber);
        query.descending("effDate");
 
        var newresultsJson = [];
        var outputRecs = [];
        var policyDocs = [];
 
        //-----------------------------------
        // Quesy against policy table
        //-----------------------------------     
        query.find().then(function(results) 
          {
                var promise = Parse.Promise.as();
                _.each(results, function(resultObj) 
                { 
     
                    promise = promise.then(function() 
                      {
                          outputRecs = [];
                          policyDocs = (resultObj.toJSON());
                          policyDocs["policyDocs"] =[ ];
            
                          var PolicyDocs  = Parse.Object.extend("PolicyDocs");
                          var querypolicydocs = new Parse.Query(PolicyDocs);
                          querypolicydocs.equalTo("policyNumber", resultObj.get("policyNumber"));
                          querypolicydocs.equalTo("policyMod", resultObj.get("policyMod"));
                          querypolicydocs.descending("docDate");

                          //-----------------------------------
                          // Quesy against doc table
                          //----------------------------------- 
                          var subPromise = Parse.Promise.as();
                          return querypolicydocs.find().then(
                                       function(thePolicyDocs)
                                             {
                                               policyDocs["policyDocs"].push(thePolicyDocs);
                                             }
                                          ).then(function() { outputRecs.push(policyDocs); });   // for each term in Policy table
                                        
                       }).then(function() { newresultsJson.push(outputRecs); });  // _promise
                       
                 });   // _each loop for each policy in Relationship table
                 return promise;

         }, function (error) {response.error("Error "+error.message); // everything is done and error on the first query find
         }).then(function() {response.success(newresultsJson);  });   // everything is done and good on the first query find
 
       
  
                    
});    // the function

Parse.Cloud.define("addpolicyforuser", function(request, response) {

   var PolicyRelationship = Parse.Object.extend("PolicyRelationship");
   var querypolrel = new Parse.Query(PolicyRelationship);
   querypolrel.equalTo("policyNumber",request.params.policyNumber);
   querypolrel.find( {
     success: function(results) {
     	//---------------------------------------
        // Already exists  in a relationship to a user?
        //---------------------------------------
        if (results.length > 0) 
        {
            response.error("Policy Is Already Assigned");
        }
        else
        {
           //---------------------------
           // Must match policynumber, zip and the objectid
           //-----------------------------------
           var Policy  = Parse.Object.extend("Policy");
           var querypol = new Parse.Query(Policy);
           querypol.equalTo("policyNumber",request.params.policyNumber);
           querypol.equalTo("policyPostalCode",request.params.policyPostalCode);
           querypol.equalTo("objectId",request.params.policyObjectId);

           querypol.find( {
               success: function(resultspol) {
                   if (resultspol.length > 0)       // if they get access to 1 of the policy terms, they have accesss to all since it is based on policyNumber
                   {

                         var User  = Parse.Object.extend("User");
                         var queryuser = new Parse.Query(User);
                         queryuser.equalTo("objectId",request.params.userId);
                         queryuser.equalTo("emailVerified",true);

                         queryuser.find( {
                             success: function(resultspol) {
                                   if (resultspol.length > 0) 
                                   {

                                            var newPolicyRelationship  = Parse.Object.extend("PolicyRelationship");
                                            var polRel = new newPolicyRelationship();

                                            polRel.set("policyNumber",request.params.policyNumber);
                                            polRel.set("userId",request.params.userId);

                                            polRel.save(null,{
                                              success:function(polRel) { 
                                                response.success(polRel);
                                              },
                                              error:function(error) {
                                                response.error(error);
                                              }
                                            });

                                   }
                                   else
                                   {
                                      response.error("User Not Found Or Email Not Verified");
                                   }
                             },
                             error: function(object, error) {
                               // The object was not retrieved successfully.
                               // error is a Parse.Error with an error code and description.
                             },

                         });

                   }
                   else
                   {
                      response.error("Policy Not Found");
                   }

               },
               error: function(object, error) {
                 // The object was not retrieved successfully.
                 // error is a Parse.Error with an error code and description.
               },

           });

        }
      },
     error: function(object, error) {
       // The object was not retrieved successfully.
       // error is a Parse.Error with an error code and description.
     }
   });
                
});




Parse.Cloud.define("getpoliciesforuser", function(request, response) {
        var _ = require('underscore');
        //-----------------------------------
        // Create a query for Policy Relationship
        //-----------------------------------
        var PolicyRelationship = Parse.Object.extend("PolicyRelationship");
        var query = new Parse.Query(PolicyRelationship);
  
        //-----------------------------------
        // Create a query for Policy Relationship
        //-----------------------------------
        query.equalTo("userId",request.params.userId);
 
        var newresultsJson = [];
        var outputRecs = [];
        var policyTermRecs = [];
 
        query.find().then(function(results) {
 
            var promise = Parse.Promise.as();
            _.each(results, function(resultObj) { 
 
                promise = promise.then(function() {
                outputRecs = [];
                policyTermRecs = (resultObj.toJSON());
                policyTermRecs["policyTerms"] =[ ];
  
                var Policy  = Parse.Object.extend("Policy");
                var querypolicy = new Parse.Query(Policy);
                querypolicy.equalTo("policyNumber", resultObj.get("policyNumber"));
                querypolicy.descending("effDate");
                var subPromise = Parse.Promise.as();
                return querypolicy.find().then(function(thePolicyTerm){
                         policyTermRecs["policyTerms"].push(thePolicyTerm);
                      }).then(function() { outputRecs.push(policyTermRecs); });   // for each term in Policy table
                              
             }).then(function() { newresultsJson.push(outputRecs); });  // _each loop for each policy in Relationship table
                   
           });   // query.find 
           return promise;
         }, function (error) {
            response.error("Error "+error.message);
         }).then(function() {
            response.success(newresultsJson);    // everything is done
 
        });
  
                    
});
 
// Parse.Cloud.define("getpoliciesforuserpromise", function(request, response) {
 
//         //-----------------------------------
//         // Create a query for Policy
//         //-----------------------------------
//         var PolicyRelationship = Parse.Object.extend("PolicyRelationship");
//         var query = new Parse.Query(PolicyRelationship);
 
//         //-----------------------------------
//         // Quesy withing X miles
//         //-----------------------------------
//         query.equalTo("userId",request.params.userId);
//         var newresultsJson = [];
//         var queries = [];
 
//         // Final list of objects
//         query.find().then(function(results) 
//                           {
                                     
//                               for (var i = 0; i<results.length; i++) 
//                               {
//                                 var inputRec = (results[i].toJSON());
//                                 newresultsJson.push(inputRec);
//                                var Policy  = Parse.Object.extend("Policy");
//                                var querypolicy = new Parse.Query(Policy);
//                                var q = querypolicy.equalTo("policyNumber",results[i].get("policyNumber")).find();
//                                queries.push(q);
 
//                               }
                               
//                           }
 
//                            ,
//                             function(object, error) 
//                           {
//                        // The object was not retrieved successfully.
//                        // erris a Parse.Error with an error code and description.
//                          }).then(function(result) {
//                                response.success(newresultsJson); //return the new modified JSON instead of the array of PFObjects        
 
//                             });
 
// // Wait for them all to complete
// Parse.Promise.when(queries).then(function( ) {
//   newresultsJson.push("sdsdsd");
//                               for (var i = 0; i<arguments.length; i++) 
//                               {
//                                 var inputRec = (arguments[i].toJSON());
//                                 newresultsJson.push(inputRec);
 
 
//                               }
     
// });
                    
// });
 
// Parse.Cloud.define("getpoliciesforuserold", function(request, response) {
 
//         //-----------------------------------
//         // Create a query for Policy
//         //-----------------------------------
//         var PolicyRelationship = Parse.Object.extend("PolicyRelationship");
//         var query = new Parse.Query(PolicyRelationship);
 
//         //-----------------------------------
//         // Quesy withing X miles
//         //-----------------------------------
//         query.equalTo("userId",request.params.userId);
 
//         // Final list of objects
//         query.find({
//                           success: function(results) 
//                           {
//                                     var newresultsJson = [];
//                                     for (var i = 0; i<results.length; i++) 
//                                     {
//                                       var inputRec = (results[i].toJSON());
//                                       newresultsJson.push(inputRec);
//                                     }
//                                     response.success(newresultsJson); //return the new modified JSON instead of the array of PFObjects        
//                              // response.success(results);
//                           },
//                           error: function(object, error) 
//                           {
//                        // The object was not retrieved successfully.
//                        // erris a Parse.Error with an error code and description.
//                          }
//                   });
// });
Parse.Cloud.define("getagenciesnearby", function(request, response) {
        //-----------------------------------
        // get the input lat / lng
        //-----------------------------------
        var inputGeoPoint = {
            latitude: request.params.lat,
            longitude: request.params.lng
        };
        //-----------------------------------
        // Create a query for Agency
        //-----------------------------------
        var Agency = Parse.Object.extend("Agency");
        var query = new Parse.Query(Agency);
        // Interested in locations near user.
        //query.near("agencyGeo", inputGeoPoint);
        //-----------------------------------
        // Quesy withing X miles
        //-----------------------------------
        query.withinMiles("agencyGeo", inputGeoPoint, request.params.miles);
        //-----------------------------------
        // Limit what could be a lot of points.
        //-----------------------------------
        query.limit(request.params.limit);
        // Final list of objects
        query.find({
                          success: function(results) 
                          {
                                    var newresultsJson = [];
                                    for (var i = 0; i<results.length; i++) 
                                    {
                                      var inputRec = (results[i].toJSON());
                                      inputRec["milesTo"] = results[i].get("agencyGeo").milesTo(inputGeoPoint); 
                                      newresultsJson.push(inputRec);
                                    }
                                    response.success(newresultsJson); //return the new modified JSON instead of the array of PFObjects        
                             // response.success(results);
                          },
                          error: function(object, error) 
                          {
                       // The object was not retrieved successfully.
                       // erris a Parse.Error with an error code and description.
                         }
                  });
});
 
Parse.Cloud.define("getagency", function(request, response) {
   var Agency = Parse.Object.extend("Agency");
   var query = new Parse.Query(Agency);
   query.equalTo("agencyCode",request.params.agencyCode);
   query.find( {
     success: function(results) {
        // The object was retrieved successfully.
        response.success(results);
      },
     error: function(object, error) {
       // The object was not retrieved successfully.
       // error is a Parse.Error with an error code and description.
     }
   });
});
Parse.Cloud.job("agencygeoMigration", function(request, status) {
    // Set up to modify user data
    Parse.Cloud.useMasterKey();
 
    var recordsUpdated = 0;
 
    // Query for all agency with GeoPoint location null
    var query = new Parse.Query("Agency");
    query.doesNotExist("agencyGeo");
    query.each(function(agency) {
        var alat = parseFloat(agency.get("agencyLatitude"));
        var along = parseFloat(agency.get("agencyLongitude"));
 
        recordsUpdated += 1;
        if (recordsUpdated % 100 === 0) {
            // Set the job's progress status
            status.message(recordsUpdated + " records updated.");
        }
 
        // Update to GeoPoint
        agency.set("agencyLat", alat);
        agency.set("agencyLong", along);
        return agency.save();
    }).then(function() {
        // Set the job's success status
        status.success("Migration completed successfully.");
    }, function(error) {
        // Set the job's error status
        console.log(error);
        status.error("Uh oh, something went wrong.");
    });
});
Parse.Cloud.job("agencygeoMigrationOrig", function(request, status) {
    // Set up to modify user data
    Parse.Cloud.useMasterKey();
 
    var recordsUpdated = 0;
 
    // Query for all agency with GeoPoint location null
    var query = new Parse.Query("Agency");
    query.doesNotExist("agencyGeo");
    query.each(function(agency) {
        var alat = parseFloat(agency.get("agencyLatitude"));
        var along = parseFloat(agency.get("agencyLongitude"));
        var location = {
            latitude: alat,
            longitude: along
        };
        if (!location.latitude || !location.longitude) {
            return Parse.Promise.error("There was an error.");
            // return Parse.Promise.resolve("I skipped a record and don't care.");
        }
 
        recordsUpdated += 1;
        if (recordsUpdated % 100 === 0) {
            // Set the job's progress status
            status.message(recordsUpdated + " records updated.");
        }
 
        // Update to GeoPoint
        agency.set("agencyGeo", new Parse.GeoPoint(location));
        return agency.save();
    }).then(function() {
        // Set the job's success status
        status.success("Migration completed successfully.");
    }, function(error) {
        // Set the job's error status
        console.log(error);
        status.error("Uh oh, something went wrong.");
    });
});
Parse.Cloud.job("bodyshopMigration", function(request, status) {
    // Set up to modify user data
    Parse.Cloud.useMasterKey();
 
    var recordsUpdated = 0;
 
    // Query for all agency with GeoPoint location null
    var query = new Parse.Query("BodyShop");
    query.doesNotExist("ShopGeo");
    query.each(function(bodyshop) {
        var alat = parseFloat(bodyshop.get("Latitude"));
        var along = parseFloat(bodyshop.get("Longitude"));
        var location = {
            latitude: alat,
            longitude: along
        };
        if (!location.latitude || !location.longitude) {
            return Parse.Promise.error("There was an error.");
            // return Parse.Promise.resolve("I skipped a record and don't care.");
        }
 
        recordsUpdated += 1;
        if (recordsUpdated % 100 === 0) {
            // Set the job's progress status
            status.message(recordsUpdated + " records updated.");
        }
 
        // Update to GeoPoint
        bodyshop.set("ShopGeo", new Parse.GeoPoint(location));
        return bodyshop.save();
    }).then(function() {
        // Set the job's success status
        status.success("Migration completed successfully.");
    }, function(error) {
        // Set the job's error status
        console.log(error);
        status.error("Uh oh, something went wrong.");
    });
});
Parse.Cloud.define("getbodyshopsnearby", function(request, response) {
        //-----------------------------------
        // get the input lat / lng
        //-----------------------------------
        var inputGeoPoint = {
            latitude: request.params.lat,
            longitude: request.params.lng
        };
        //-----------------------------------
        // Create a query for BodySHop
        //-----------------------------------
        var BodyShop = Parse.Object.extend("BodyShop");
        var query = new Parse.Query(BodyShop);
 
        //-----------------------------------
        // Quesy withing X miles
        //-----------------------------------
        query.withinMiles("ShopGeo", inputGeoPoint, request.params.miles);
        //-----------------------------------
        // Limit what could be a lot of points.
        //-----------------------------------
        query.limit(request.params.limit);
        // Final list of objects
        query.find({
                          success: function(results) 
                          {
                                    var newresultsJson = [];
                                    for (var i = 0; i<results.length; i++) 
                                    {
                                      var inputRec = (results[i].toJSON());
                                      inputRec["milesTo"] = results[i].get("ShopGeo").milesTo(inputGeoPoint); 
                                      newresultsJson.push(inputRec);
                                    }
                                    response.success(newresultsJson); //return the new modified JSON instead of the array of PFObjects        
                             // response.success(results);
                          },
                          error: function(object, error) 
                          {
                       // The object was not retrieved successfully.
                       // erris a Parse.Error with an error code and description.
                         }
                  });
});
 
Parse.Cloud.define("getbodyshop", function(request, response) {
   var BodyShop = Parse.Object.extend("BodyShop");
   var query = new Parse.Query(BodyShop);
   query.equalTo("BodyShopId",request.params.BodyShopId);
   query.find( {
     success: function(results) {
        // The object was retrieved successfully.
        response.success(results);
      },
     error: function(object, error) {
       // The object was not retrieved successfully.
       // error is a Parse.Error with an error code and description.
     }
   });
});
