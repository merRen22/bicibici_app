class Plan{
  String uuidPlan,name,description;
  int cost;
  int duration;

  Plan();
  
  factory Plan.fromJson(parsedJson){
   Plan plan = Plan();
   plan.uuidPlan = parsedJson['uuidPlan'];
   plan.name = parsedJson['name'];
   plan.description = parsedJson['description'];
   plan.cost = parsedJson['cost'];
   plan.duration = parsedJson['duration'];
   return plan;
 }
}