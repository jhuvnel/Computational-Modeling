LP = getAxisCurrent(fem, LPd, LPp, [37.9688 54.375 40.7813]);
LA = getAxisCurrent(fem, LAd, LAp, [45.4688 23.4375 39.375]);
LH = getAxisCurrent(fem, LHd, LHp, [48.75,26.7188,38.4375]);

ActualAxis = [12.5 22.5 65];
ActualAxis = ActualAxis/norm(ActualAxis);

ModelAxis = [LA LH LP];
ModelAxis = ModelAxis/norm(ModelAxis);

cosTheta = dot(ModelAxis, ActualAxis);