using CP; 
dvar interval CollectMaterial size 1; 
dvar interval CollectKit      size 1; 
dvar interval GetTube; 
dvar interval WeldTube        size 15; 
dvar interval SawRod          size 10; 
dvar interval ClearRod        size 2;
dvar interval AssembleKit     size 5; 
dvar interval WeldRod         size 15; 
dvar interval AssemblePiston  size 5; 
dvar interval ShipPiston in 0..70; 
dvar interval BuyTube   optional size 40;
dvar interval SawTube   optional size 30; 
dvar interval ClearTube optional size 20; 
dvar interval MakeTube  optional;
dvar interval MakeTubeSpan[1..2] = 
  [SawTube, ClearTube]; 
dvar interval GetTubeAlt[1..2] = [BuyTube, MakeTube]; 

  constraints {
 span(MakeTube, MakeTubeSpan); 
 presenceOf(MakeTube) => 
   presenceOf(SawTube) && 
   presenceOf(ClearTube); 
 alternative(GetTube, GetTubeAlt); 
 endBeforeStart(CollectMaterial, GetTube); 
 endBeforeStart(CollectMaterial, SawRod); 
 endBeforeStart(CollectKit,  AssembleKit); 
 endBeforeStart(SawTube,     ClearTube); 
 endBeforeStart(GetTube,     WeldTube); 
 endBeforeStart(SawRod,      ClearRod); 
 endBeforeStart(ClearRod,    WeldRod); 
 endBeforeStart(AssembleKit, WeldRod); 
 endBeforeStart(WeldTube, AssemblePiston); 
 endBeforeStart(WeldRod,  AssemblePiston); 
 endBeforeStart(AssemblePiston, 
                ShipPiston);
  }
execute{    writeln("CollectMaterial  : " + CollectMaterial.start   + "---" + CollectMaterial.end);
 writeln("ShipPiston  : " + ShipPiston.start   + "---" + ShipPiston.end);
  writeln("CollectMaterial"+CollectMaterial)
 writeln("GetTube  : " + GetTube);
  writeln("GetTube  : " + GetTube);



 } 
