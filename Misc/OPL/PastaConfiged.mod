/*********************************************
 * OPL 22.1.0.0 Model
 * Author: m_gor
 * Creation Date: Nov 17, 2022 at 1:49:21 PM
 *********************************************/

execute PARAMS {
  cplex.threads= 3;
  cplex.tilim= 150;
}

tuple TProduct {
  key string name;
  float demand;
  float insideCost;
  float outsideCost;
};

tuple TResource {
  key string name;
  float capacity;
};

tuple TConsumption {
  key string productId;
  key string resourceId;
  float consumption; 
}

{TProduct}     Products = ...;
{TResource}    Resources = ...;
{TConsumption} Consumptions = ...;

/// solution
tuple TPlannedProduction {
  key string productId;
  float insideProduction;
  float outsideProduction; 
}

/// variables.
dvar float+ Inside [Products];
dvar float+ Outside[Products];

dexpr float totalInsideCost  = sum(p in Products)  p.insideCost * Inside[p];
dexpr float totalOutsideCost = sum(p in Products)  p.outsideCost * Outside[p];

minimize
  totalInsideCost + totalOutsideCost;
   
subject to {
  forall( r in Resources )
    ctCapacity: 
      sum( k in Consumptions, p in Products 
           : k.resourceId == r.name && p.name == k.productId ) 
        k.consumption* Inside[p] <= r.capacity;

  forall(p in Products)
    ctDemand:
      Inside[p] + Outside[p] >= p.demand;
}

{TPlannedProduction} plan = {<p.name, Inside[p], Outside[p]> | p in Products};

execute{ 
  writeln("Generating Outputs")
	writeln(plan);
}