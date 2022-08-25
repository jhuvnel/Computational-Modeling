function out = model
%
% FEM_20220628.m
%
% Model exported on Jun 28 2022, 11:03 by COMSOL 6.0.0.318.

import com.comsol.model.*
import com.comsol.model.util.*

ModelUtil.showProgress(true); %activates progress bar
model = ModelUtil.create('Model');

model.modelPath('R:\Morris, Brian\Computational Modeling\FEM Models\Model as of 20220628');

%Create Model Component
model.component.create('comp1', true);
%Create Model Geometry
model.component('comp1').geom.create('geom1', 3);
%Create Model Mesh
model.component('comp1').mesh.create('mesh1');

%Add Model physics (CurvilinearCoordinates for Facial, cochlear, and
%Vestibular Nerves and Electric Currents)
model.component('comp1').physics.create('cc', 'CurvilinearCoordinates', 'geom1');
model.component('comp1').physics.create('cc2', 'CurvilinearCoordinates', 'geom1');
model.component('comp1').physics.create('cc3', 'CurvilinearCoordinates', 'geom1');
model.component('comp1').physics.create('ec', 'ConductiveMedia', 'geom1');

%Import desired geometry
model.component('comp1').geom('geom1').create('imp1', 'Import'); %Creating import option
model.component('comp1').geom('geom1').feature('imp1').set('type', 'cad'); %Setting import type
model.component('comp1').geom('geom1').feature('imp1').set('unit', 'source'); %Setting source for units
model.component('comp1').geom('geom1').feature('imp1').set('keepbnd', false); %Geometry loading preferences
model.component('comp1').geom('geom1').feature('imp1').set('removeredundant', true); %Remove redundant edges?
model.component('comp1').geom('geom1').feature('imp1').set('selresult', true); %Selection Results options
model.component('comp1').geom('geom1').feature('imp1').set('selresultshow', 'all'); %Selection Results Settings
model.component('comp1').geom('geom1').feature('imp1').set('selindividual', true); %Selection Results options
model.component('comp1').geom('geom1').feature('imp1').set('selindividualshow', 'all'); %Selection Results Settings
model.component('comp1').geom('geom1').feature('imp1').set('filename', 'R:\Morris, Brian\Computational Modeling\Finished Monkey Geometry\Geometry Components\Assembly 2\Full Geometry - Split Nerves.SLDASM');
model.component('comp1').geom('geom1').feature('imp1').importData;
model.component('comp1').geom('geom1').run('fin');

%Create Facial Inlet Explicit Selection
model.component('comp1').geom('geom1').create('sel1', 'ExplicitSelection');
model.component('comp1').geom('geom1').feature('sel1').label('Facial Inlet');
model.component('comp1').geom('geom1').feature('sel1').selection('selection').init(2);
model.component('comp1').geom('geom1').feature('sel1').selection('selection').set('fin', [53865 53866 53867 53868 53932 53933 53935 53963 53964 54016 54159 54160 54268 54269 54270 54324 54325 54326 54335 54346 54351 54352 54516 54518 54542 54543 54544 54557 54560 54561 54562 54596 54639 54652 54720 54764 54777 54782 54831 54857 54860 54861 54874]);
model.component('comp1').geom('geom1').run('sel1');

%Create Facial Outlet Explicit Selection
model.component('comp1').geom('geom1').create('sel2', 'ExplicitSelection');
model.component('comp1').geom('geom1').feature('sel2').label('Facial Outlet');
model.component('comp1').geom('geom1').feature('sel2').selection('selection').init(2);
model.component('comp1').geom('geom1').feature('sel2').selection('selection').set('fin', [4688 4689 4690 4691 4692 4693 4694 4695 4696 4709 4714 4715 4761 4762 4789 4790 4791 4792 4793 4988 4989 5042 5043 5142 5144 5246 5275 5285 5537 5538]);
model.component('comp1').geom('geom1').run('sel2');

%Create Cochlea Inlet Explicit Selection
model.component('comp1').geom('geom1').create('sel3', 'ExplicitSelection');
model.component('comp1').geom('geom1').feature('sel3').label('Cochlea Inlet');
model.component('comp1').geom('geom1').feature('sel3').selection('selection').init(2);
model.component('comp1').geom('geom1').feature('sel3').selection('selection').set('fin', [48349 49739 49740 49790 49804 49814 49829 49831 49842 49846 49875 49953 49969 49970 49982 49988 50039 50040 50041 50126 50127 50144 50145 50250 50351 50352 50353 50418 50476 50477 50495 50636 50637 50683 50732 50801 50824 50825 50849 50920 50921 50922 51150 51210 51211 51250 51251 51396 51397 51458 51541 51574 51604 51605 51606 51667 51774 51818 51819 52029 52030 52031 52032 52123 52141 52142 52167 52226 52315 52316]);
model.component('comp1').geom('geom1').run('sel3');

%Create Cochlea Outlet Explicit Selection
model.component('comp1').geom('geom1').create('sel4', 'ExplicitSelection');
model.component('comp1').geom('geom1').feature('sel4').selection('selection').init(2);
model.component('comp1').geom('geom1').feature('sel4').label('Cochlea Outlet');
model.component('comp1').geom('geom1').feature('sel4').selection('selection').set('fin', [36384 36385 36386 36387 36388 36389 36405 36406 36408 36410 36411 36412 36415 36416 36417 36418 36419 36427 36431 36432 36433 36457 36458 36460 36511 36512 36647 36648 36649 36650 36675 36676 36680 36688 36694 36695 36696 36713 36714 36715 36718 36739 36740 36741 36745 36746 36760 36761 36762 36763 36795 36796 36797 36838 36898 36899 36900 36901 36902 36943 36962 37002 37085 37086 37161 37162 37166 37210 37211 37212 37244 37245 37249 37325 37326 37327 37354 37359 37363 37372 37393 37394 37395 37396 37425 37426 37427 37451 37479 37480 37481 37493 37494 37567 37568 37570 37598 37717 37718 37858 37933 38179 38235 38258 38260 38653 38789 38922 38923 38924 39237 39238 39565 39621 39714 39754 39755 40135 40137 40194 40195 40384 40385 40527 40529 40554 40556 40778 40783 40784 40876 40877 41055 41133 41292 41366 41367 41369 41646 41755 41756 41757 41809 41810 41811 41965 41978 41991 41992 41993 42003 42004 42005 42063 42096 42108 42109 42110 42120 42121 42491 42515 42516 42525 42590 42592 42607 42671 42672 42678 42679 42758 42759 42760 42888 42902 42903 43014 43015 43056 43058 43181 43182 43196 43199 43249 43251 43281 43282 43387 43546 43548 43549 43565 43566 43578 43650 43652 43679 43881 43884 43896 43897 43925 43927 44045 44140 44147 44149 44161 44162 44163 44164 44188 44208 44209 44236 44272 44273 44284 44285 44286 44409 44475 44476 44477 44478 44486 44491 44493 44510 44511 44529 44537 44681 44682 44703 44727 44740 44833 44834 44843 44844 44887 44888 44889 45050 45052 45053 45066 45067 45088 45089 45095 45096 45099 45177 45261 45262 45297 45298 45327 45328 45329 45375 45376 45435 45436 45445 45447 45448 45460 45461 45462 45499 45500 45555 45656 45657 45686 45687 45717 45737 45739 45755 45756 45757 45780 45782 45868 45869 45870 45955 45956 45962 45963 45990 46007 46008 46019 46020 46021 46033 46034 46035 46066 46148 46149 46173 46174 46175 46176 46178 46200 46209 46210 46211 46276 46277 46278 46291 46293 46294 46366 46367 46380 46381 46437 46438 46464 46465 46467 46515 46516 46551 46580 46581 46582 46591 46695 46697 46727 46739 46749 46750 46751 46782 46783 46784 46797 46798 46799 46824 46827 46828 46846 46857 46858 46895 46974 46975 46981 47008 47009 47013 47042 47071 47072 47073 47108 47109 47149 47150 47191 47192 47217 47218 47228 47229 47254 47255 47257 47258 47301 47302 47325 47327 47348 47371 47377 47378 47388 47398 47399 47400 47408 47434 47435 47436 47461 47462 47478 47486 47502 47560 47561 47563 47567 47580 47581 47582 47591 47592 47603 47604 47612 47613 47614 47615 47616 47618 47619 47620 47621 47636 47637 47659 47660 47661 47662 47668 47689 47690 47691 47700 47704 47725 47729 47730 47756 47757 47812 47813 47866 47867 47870 47871 47881 47906 47907 47927 47940 47941 47961 47973 47974 47976 47981 47982 47983 47990 48000 48005 48037 48038 48120 48121 48158 48224 48225 48226 48227 48281 48288 48310 48353 48380 48409 48419 48420 48552 48553 48558 48588 48589 48668 48669 48852 48853 48854 48965 48967 49016 49177 49179 49180 49193 49195 49341 49342 49345 49372 49593 49594 49595 49596 49597 49613 49614 49632 49633 49634 49635 49636 49637 49693 49745 49746 49747 49755 49757 49762 49769 49770 49771 49772 49807 49808 49911 49916 50013 50014 50112 50113 50114 50156 50167 50168 50178 50246 50247 50253 50254 50255 50333 50334 50345 50346 50347 50348 50362 50392 50438 50545 50592 50593]);
model.component('comp1').geom('geom1').run('sel4');

%Create Vestibular Inlet Explicit Selection
model.component('comp1').geom('geom1').create('sel5', 'ExplicitSelection');
model.component('comp1').geom('geom1').feature('sel5').label('Vestibular Inlet');
model.component('comp1').geom('geom1').feature('sel5').selection('selection').init(2);
model.component('comp1').geom('geom1').feature('sel5').selection('selection').set('fin', [47180 47181 47182 47203 47204 47214 47215 47216 47405 47406 47539 47540 47721 47763 47764 47810 47811 47839 47969 47970 48039 48040 48128 48129 48264 48265 48338 48339 48361 48362 48422 48423 48818 48819 48820 48827 48836 48837 48862 48903 48904 48907 48915 48916 49043 49136 49137 49208 49236 49237 49238 49309 49310 49313 49314 49326 49327 49477 49478 49608 49609 49610 49611 49658 49660 49686 49687 49690 49691 49692 49720 49885 49886 49887 49947 49948 49949 50118 50119 50162 50169 50170 50208 50273 50604 50605 50606 50691 50692 50693 50694 50695 50696 50697 50771 50772 50784 50785 50786 50805 50826 50905 50924 50925 50926 51043 51044 51066 51073 51074 51137 51164 51165 51357 51358 51359 51453 51454 51455 51511 51521 51583 51584 51652 51653 51654 51655 51677 51696 51707 51749 51750 51751 51880 51940 51941 51999 52039 52040 52149]);
model.component('comp1').geom('geom1').run('sel5');

%Create Vestibular Outlet Explicit Selection
model.component('comp1').geom('geom1').create('sel6', 'ExplicitSelection');
model.component('comp1').geom('geom1').feature('sel6').label('Vestibular Outlet');
model.component('comp1').geom('geom1').feature('sel6').selection('selection').init(2);
model.component('comp1').geom('geom1').feature('sel6').selection('selection').set('fin', [25046 25047 25048 25049 25050 25051 25052 25053 25123 25124 25125 25126 25216 25217 25218 25281 25338 25339 25340 25360 25457 25458 25459 25460 25467 25468 25469 25485 25644 25645 25663 25693 25694 25695 25781 25796 25856 25857 25858 25859 25887 25888 25889 25903 25904 26168 26212 26270 26271 26434 26446 26447 26505 26541 26550 26694 26720 26721 26722 26723 26815 26816 26817 26981 26982 26983 27084 27085 27188 27189 27251 27252 27253 27268 27269 27270 27271 27312 27313 27323 27331 27332 27337 27437 27438 27439 27582 27583 27663 27664 27665 27707 27708 27724 27770 27771 27772 27930 27931 27955 27956 27957 27958 27959 27990 27991 27993 27994 28052 28054 28078 28106 28107 28108 28162 28177 28203 28204 28205 28212 28213 28214 28215 28277 28278 28279 28318 28319 28328 28380 28432 28433 28435 28436 28461 28462 28494 28495 28506 28507 28508 28509 28512 28513 28514 28579 28580 28586 28587 28619 28620 28621 28622 28623 28644 28645 28682 28683 28737 28738 28795 28796 28802 28803 28960 29018 29081 29082 29102 29103 29104 29151 29152 29153 29171 29181 29182 29183 29184 29209 29210 29211 29212 29222 29223 29224 29253 29254 29255 29259 29260 29261 29292 29293 29294 29319 29320 29321 29322 29323 29336 29337 29370 29374 29375 29376 29377 29399 29400 29401 29421 29422 29435 29436 29437 29438 29459 29460 29531 29547 29548 29549 29563 29564 29565 29566 29595 29596 29604 29605 29606 29633 29635 29638 29639 29640 29665 29666 29748 29749 29750 29789 29790 29791 29801 29802 29821 29822 29862 29863 29874 29875 29899 29912 29913 29921 29925 29973 29974 30049 30050 30051 30077 30142 30143 30177 30178 30201 30215 30216 30217 30271 30332 30428 30429 30430 30431 30442 30443 30500 30501 30502 30515 30516 30560 30561 30567 30568 30569 30571 30572 30619 30665 30724 30725 30726 30752 30753 30760 30761 30804 30805 30808 30809 30817 30818 30819 30820 30821 30899 30900 30903 30904 30936 30956 30969 30981 30982 30983 31007 31008 31013 31014 31028 31029 31030 31031 31032 31035 31036 31037 31038 31039 31040 31041 31046 31047 31048 31049 31064 31065 31066 31078 31079 31084 31085 31086 31087 31088 31093 31094 31095 31107 31117 31118 31119 31125 31126 31127 31133 31158 31159 31166 31193 31195 31196 31201 31202 31224 31225 31226 31240 31241 31247 31248 31249 31250 31299 31300 31303 31304 31305 31316 31317 31366 31367 31370 31371 31386 31387 31448 31449 31450 31454 31455 31456 31464 31465 31476 31477 31482 31483 31484 31485 31486 31497 31498 31504 31505 31506 31507 31508 31509 31510 31511 31514 31516 31522 31531 31532 31533 31555 31561 31564 31565 31570 31571 31572 31598 31599 31600 31609 31610 31636 31637 31638 31662 31663 31664 31665 31666 31667 31668 31669 31673 31674 31705 31717 31718 31731 31732 31741 31746 31747 31781 31782 31784 31785 31786 31787 31793 31794 31801 31802 31805 31806 31807 31808 31816 31821 31822 31823 31824 31843 31844 31849 31850 31853 31859 31860 31878 31906 31907 31920 31948 31949 31952 31987 31988 31989 31990 31991 31992 31996 31997 31998 32004 32005 32006 32007 32008 32019 32020 32024 32025 32031 32032 32033 32040 32041 32047 32048 32061 32062 32063 32064 32082 32083 32084 32111 32130 32142 32171 32176 32177 32178 32183 32184 32188 32189 32190 32191 32199 32200 32201 32202 32203 32204 32205 32210 32211 32212 32213 32214 32215 32216 32224 32226 32227 32228 32229 32238 32239 32259 32260 32261 32263 32264 32265 32266 32284 32285 32319 32320 32321 32322 32325 32326 32327 32338 32339 32340 32347 32370 32371 32372 32385 32386 32393 32394 32395 32423 32424 32425 32431 32445 32449 32453 32454 32478 32479 32487 32488 32489 32495 32496 32504 32505 32559 32560 32561 32578 32579 32591 32596 32597 32598 32599 32630 32636 32637 32638 32639 32675 32677 32678 32679 32680 32681 32683 32690 32691 32692 32693 32695 32696 32698 32699 32709 32710 32711 32712 32717 32718 32719 32755 32756 32757 32765 32766 32784 32785 32790 32791 32799 32819 32820 32841 32842 32845 32846 32847 32848 32857 32858 32859 32873 32874 32875 32876 32877 32878 32879 32883 32884 32902 32948 32949 32956 32957 32958 32967 32983 32984 32985 32986 33000 33001 33002 33009 33010 33011 33018 33019 33020 33021 33022 33023 33031 33032 33048 33049 33059 33060 33061 33073 33074 33102 33103 33117 33118 33134 33135 33142 33143 33144 33162 33164 33168 33169 33181 33182 33192 33193 33209 33210 33211 33212 33213 33221 33223 33224 33225 33226 33227 33228 33232 33235 33236 33237 33239 33242 33252 33253 33254 33255 33259 33260 33267 33268 33276 33277 33282 33283 33294 33295 33296 33297 33298 33313 33314 33320 33340 33341 33345 33346 33357 33390 33391 33392 33393 33394 33395 33406 33407 33432 33433 33442 33443 33466 33473 33474 33482 33483 33494 33505 33506 33511 33513 33514 33515 33547 33557 33558 33561 33562 33563 33580 33582 33583 33596 33597 33598 33615 33616 33617 33622 33623 33624 33635 33636 33637 33642 33643 33646 33690 33691 33692 33693 33694 33695 33696 33700 33701 33702 33731 33740 33741 33748 33749 33750 33754 33787 33788 33789 33790 33794 33817 33818 33819 33823 33824 33848 33849 33850 33862 33863 33878 33879 33880 33881 33887 33888 33889 33890 33891 33954 33955 33960 33962 33963 33972 33973 33975 34003 34004 34005 34010 34011 34033 34034 34036 34037 34038 34050 34051 34070 34071 34072 34086 34138 34139 34210 34211 34254 34255 34276 34277 34385 34387 34388 34389 34439 34440 34495 34504 34505 34547 34548 34549 34568 34569 34583]);
model.component('comp1').geom('geom1').run('sel6');

model.component('comp1').geom('geom1').run;

%Define Material 1 as Nerve
model.component('comp1').material.create('mat1', 'Common');
model.component('comp1').material('mat1').label('Nerve');
model.component('comp1').material('mat1').selection.set([5 11 16 17 18 19 20]); %Domains to select
model.component('comp1').material('mat1').propertyGroup('def').set('electricconductivity', {'.3333' '0' '0' '0' '.0143' '0' '0' '0' '.0143'});
model.component('comp1').material('mat1').propertyGroup('def').set('relpermittivity', {'35600'});

model.component('comp1').material.create('mat2', 'Common');
model.component('comp1').material('mat2').label('Lumen');
model.component('comp1').material('mat2').selection.set([6]);
model.component('comp1').material('mat2').propertyGroup('def').set('electricconductivity', {'2'});
model.component('comp1').material('mat2').propertyGroup('def').set('relpermittivity', {'109'});

model.component('comp1').material.create('mat3', 'Common');
model.component('comp1').material('mat3').label('Electrodes');
model.component('comp1').material('mat3').selection.set([7 9 10 12 13 14 15]);
model.component('comp1').material('mat3').propertyGroup('def').set('electricconductivity', {'4000000'});
model.component('comp1').material('mat3').propertyGroup('def').set('relpermittivity', {'1'});

model.component('comp1').material.create('mat4', 'Common');
model.component('comp1').material('mat4').label('Body');
model.component('comp1').material('mat4').selection.set([2 3]);
model.component('comp1').material('mat4').propertyGroup('def').set('electricconductivity', {'.17211'});
model.component('comp1').material('mat4').propertyGroup('def').set('relpermittivity', {'1660'});

model.component('comp1').material.create('mat5', 'Common');
model.component('comp1').material('mat5').label('Bone');
model.component('comp1').material('mat5').selection.set([1]);
model.component('comp1').material('mat5').propertyGroup('def').set('electricconductivity', {'.013889'});
model.component('comp1').material('mat5').propertyGroup('def').set('relpermittivity', {'1660'});

model.component('comp1').material.create('mat6', 'Common');
model.component('comp1').material('mat6').label('Parafloculous');
model.component('comp1').material('mat6').selection.set([4 8]);
model.component('comp1').material('mat6').propertyGroup('def').set('electricconductivity', {'.3333'});
model.component('comp1').material('mat6').propertyGroup('def').set('relpermittivity', {'22500'});


model.component('comp1').physics('cc').prop('Settings').set('CreateBasis', true);
model.component('comp1').physics('cc').create('flow1', 'FlowMethod', 3);
model.component('comp1').physics('cc').label('Curvilinear Coordinates - Facial');
model.component('comp1').physics('cc').selection.named('geom1_imp1_Facial_Nerve1_dom');
model.component('comp1').physics('cc').feature('flow1').create('inl1', 'Inlet', 2);
model.component('comp1').physics('cc').feature('flow1').feature('inl1').selection.named('geom1_sel1');
model.component('comp1').physics('cc').feature('flow1').create('out1', 'Outlet', 2);
model.component('comp1').physics('cc').feature('flow1').feature('out1').selection.named('geom1_sel2');

model.component('comp1').physics('cc2').label('Curvilinear Coordinates - Cochlear');
model.component('comp1').physics('cc2').selection.named('geom1_imp1_Cochlear_Nerve1_dom');
model.component('comp1').physics('cc2').prop('Settings').set('CreateBasis', true);
model.component('comp1').physics('cc2').create('flow1', 'FlowMethod', 3);
model.component('comp1').physics('cc2').feature('flow1').create('inl1', 'Inlet', 2);
model.component('comp1').physics('cc2').feature('flow1').feature('inl1').selection.named('geom1_sel3');
model.component('comp1').physics('cc2').feature('flow1').create('out1', 'Outlet', 2);
model.component('comp1').physics('cc2').feature('flow1').feature('out1').selection.named('geom1_sel4');

model.component('comp1').physics('cc3').label('Curvilinear Coordinates - Vestibular');
model.component('comp1').physics('cc3').selection.named('geom1_imp1_Vestibular_Nerve1_dom');
model.component('comp1').physics('cc3').prop('Settings').set('CreateBasis', true);
model.component('comp1').physics('cc3').create('flow1', 'FlowMethod', 3);
model.component('comp1').physics('cc3').feature('flow1').create('inl1', 'Inlet', 2);
model.component('comp1').physics('cc3').feature('flow1').feature('inl1').selection.named('geom1_sel5');
model.component('comp1').physics('cc3').feature('flow1').create('out1', 'Outlet', 2);
model.component('comp1').physics('cc3').feature('flow1').feature('out1').selection.named('geom1_sel6');

model.component('comp1').physics('ec').create('pot1', 'ElectricPotential', 2);
%model.component('comp1').physics('ec').feature('pot1').selection.named('geom1_imp1_electrodes1_1_bnd');
model.component('comp1').physics('ec').feature('pot1').set('V0', 1);

model.component('comp1').physics('ec').create('gnd1', 'Ground', 2);
%model.component('comp1').physics('ec').feature('gnd1').selection.named('geom1_imp1_electrodes1_2_bnd');

model.component('comp1').mesh('mesh1').automatic(false);

model.component('comp1').mesh('mesh1').run('ftet1');

model.study.create('std1');
model.study('std1').create('stat', 'Stationary');
model.study('std1').feature('stat').setSolveFor('/physics/cc', true);
model.study('std1').feature('stat').setSolveFor('/physics/cc2', true);
model.study('std1').feature('stat').setSolveFor('/physics/cc3', true);
model.study('std1').feature('stat').setSolveFor('/physics/ec', true);

model.study.create('std2');
model.study('std2').create('stat', 'Stationary');
model.study('std2').feature('stat').setSolveFor('/physics/cc', true);
model.study('std2').feature('stat').setSolveFor('/physics/cc2', true);
model.study('std2').feature('stat').setSolveFor('/physics/cc3', true);
model.study('std2').feature('stat').setSolveFor('/physics/ec', true);

model.study.create('std3');
model.study('std3').create('stat', 'Stationary');
model.study('std3').feature('stat').setSolveFor('/physics/cc', true);
model.study('std3').feature('stat').setSolveFor('/physics/cc2', true);
model.study('std3').feature('stat').setSolveFor('/physics/cc3', true);
model.study('std3').feature('stat').setSolveFor('/physics/ec', true);

model.study.create('std4');
model.study('std4').create('stat', 'Stationary');
model.study('std4').feature('stat').setSolveFor('/physics/cc', true);
model.study('std4').feature('stat').setSolveFor('/physics/cc2', true);
model.study('std4').feature('stat').setSolveFor('/physics/cc3', true);
model.study('std4').feature('stat').setSolveFor('/physics/ec', true);

model.study('std1').label('Study 1 - Facial CC');
model.study('std1').feature('stat').setEntry('activate', 'cc2', false);
model.study('std1').feature('stat').setEntry('activate', 'cc3', false);
model.study('std1').feature('stat').setEntry('activate', 'ec', false);
model.study('std1').setStoreSolution(true);

model.study('std2').label('Study 2 - Cochlear CC');
model.study('std2').feature('stat').setEntry('activate', 'cc', false);
model.study('std2').feature('stat').setEntry('activate', 'cc3', false);
model.study('std2').feature('stat').setEntry('activate', 'ec', false);
model.study('std2').setStoreSolution(true);

model.study('std3').label('Study 3 - Vestibular CC');
model.study('std3').feature('stat').setEntry('activate', 'cc', false);
model.study('std3').feature('stat').setEntry('activate', 'cc2', false);
model.study('std3').feature('stat').setEntry('activate', 'ec', false);
model.study('std3').setStoreSolution(true);

model.study('std4').label('Study 4 - Electric Currents');
model.study('std4').feature('stat').setEntry('activate', 'cc', false);
model.study('std4').feature('stat').setEntry('activate', 'cc2', false);
model.study('std4').feature('stat').setEntry('activate', 'cc3', false);
model.study('std4').setStoreSolution(true);

model.sol.create('sol1');
model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', 'auto');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', 'auto');

model.sol('sol1').create('st1', 'StudyStep');
model.sol('sol1').feature('st1').set('study', 'std1');
model.sol('sol1').feature('st1').set('studystep', 'stat');
model.sol('sol1').create('v1', 'Variables');
model.sol('sol1').feature('v1').set('control', 'stat');
model.sol('sol1').create('s1', 'Stationary');
model.sol('sol1').feature('s1').create('fc1', 'FullyCoupled');
model.sol('sol1').feature('s1').feature('fc1').set('linsolver', 'dDef');
model.sol('sol1').feature('s1').feature.remove('fcDef');
model.sol('sol1').attach('std1');

model.result.create('pg1', 'PlotGroup3D');
model.result('pg1').label('Vector Field (cc)');
model.result('pg1').set('titlecolor', 'black');
model.result('pg1').set('edgecolor', 'black');
model.result('pg1').set('legendcolor', 'black');
model.result('pg1').set('data', 'dset1');
model.result('pg1').feature.create('str1', 'Streamline');
model.result('pg1').feature('str1').set('posmethod', 'uniform');
model.result('pg1').feature('str1').set('udist', 0.03);
model.result('pg1').feature('str1').set('linetype', 'line');
model.result('pg1').feature('str1').set('smooth', 'internal');
model.result('pg1').feature('str1').set('maxlen', Inf);
model.result('pg1').feature('str1').set('maxtime', Inf);
model.result('pg1').feature('str1').set('maxlen', Inf);
model.result('pg1').feature('str1').set('maxtime', Inf);
model.result('pg1').feature('str1').set('maxlen', Inf);
model.result('pg1').feature('str1').set('maxtime', Inf);
model.result('pg1').feature('str1').set('maxlen', Inf);
model.result('pg1').feature('str1').set('maxtime', Inf);
model.result('pg1').feature('str1').set('maxlen', Inf);
model.result('pg1').feature('str1').set('maxtime', Inf);
model.result('pg1').feature('str1').set('data', 'parent');

model.result.create('pg2', 'PlotGroup3D');
model.result('pg2').set('data', 'dset1');
model.result('pg2').label('Coordinate system (cc)');
model.result('pg2').create('sys1', 'CoordSysVolume');
model.result('pg2').feature('sys1').set('sys', 'cc_cs');


model.sol.create('sol2');
model.sol('sol2').study('std2');

model.study('std2').feature('stat').set('notlistsolnum', 1);
model.study('std2').feature('stat').set('notsolnum', 'auto');
model.study('std2').feature('stat').set('listsolnum', 1);
model.study('std2').feature('stat').set('solnum', 'auto');

model.sol('sol2').create('st1', 'StudyStep');
model.sol('sol2').feature('st1').set('study', 'std2');
model.sol('sol2').feature('st1').set('studystep', 'stat');
model.sol('sol2').create('v1', 'Variables');
model.sol('sol2').feature('v1').set('control', 'stat');
model.sol('sol2').create('s1', 'Stationary');
model.sol('sol2').feature('s1').create('fc1', 'FullyCoupled');
model.sol('sol2').feature('s1').feature('fc1').set('linsolver', 'dDef');
model.sol('sol2').feature('s1').feature.remove('fcDef');
model.sol('sol2').attach('std2');

model.result.create('pg3', 'PlotGroup3D');
model.result('pg3').label('Vector Field (cc2)');
model.result('pg3').set('titlecolor', 'black');
model.result('pg3').set('edgecolor', 'black');
model.result('pg3').set('legendcolor', 'black');
model.result('pg3').set('data', 'dset2');
model.result('pg3').feature.create('str1', 'Streamline');
model.result('pg3').feature('str1').set('expr', {'cc2.vX' 'cc2.vY' 'cc2.vZ'});
model.result('pg3').feature('str1').set('posmethod', 'uniform');
model.result('pg3').feature('str1').set('udist', 0.03);
model.result('pg3').feature('str1').set('linetype', 'line');
model.result('pg3').feature('str1').set('smooth', 'internal');
model.result('pg3').feature('str1').set('maxlen', Inf);
model.result('pg3').feature('str1').set('maxtime', Inf);
model.result('pg3').feature('str1').set('maxlen', Inf);
model.result('pg3').feature('str1').set('maxtime', Inf);
model.result('pg3').feature('str1').set('maxlen', Inf);
model.result('pg3').feature('str1').set('maxtime', Inf);
model.result('pg3').feature('str1').set('maxlen', Inf);
model.result('pg3').feature('str1').set('maxtime', Inf);
model.result('pg3').feature('str1').set('maxlen', Inf);
model.result('pg3').feature('str1').set('maxtime', Inf);
model.result('pg3').feature('str1').set('data', 'parent');
model.result.create('pg4', 'PlotGroup3D');
model.result('pg4').set('data', 'dset2');
model.result('pg4').label('Coordinate system (cc2)');
model.result('pg4').create('sys1', 'CoordSysVolume');
model.result('pg4').feature('sys1').set('sys', 'cc2_cs');

model.sol.create('sol3');
model.sol('sol3').study('std3');

model.study('std3').feature('stat').set('notlistsolnum', 1);
model.study('std3').feature('stat').set('notsolnum', 'auto');
model.study('std3').feature('stat').set('listsolnum', 1);
model.study('std3').feature('stat').set('solnum', 'auto');

model.sol('sol3').create('st1', 'StudyStep');
model.sol('sol3').feature('st1').set('study', 'std3');
model.sol('sol3').feature('st1').set('studystep', 'stat');
model.sol('sol3').create('v1', 'Variables');
model.sol('sol3').feature('v1').set('control', 'stat');
model.sol('sol3').create('s1', 'Stationary');
model.sol('sol3').feature('s1').create('fc1', 'FullyCoupled');
model.sol('sol3').feature('s1').feature('fc1').set('linsolver', 'dDef');
model.sol('sol3').feature('s1').feature.remove('fcDef');
model.sol('sol3').attach('std3');

model.result.create('pg5', 'PlotGroup3D');
model.result('pg5').label('Vector Field (cc3)');
model.result('pg5').set('titlecolor', 'black');
model.result('pg5').set('edgecolor', 'black');
model.result('pg5').set('legendcolor', 'black');
model.result('pg5').set('data', 'dset3');
model.result('pg5').feature.create('str1', 'Streamline');
model.result('pg5').feature('str1').set('expr', {'cc3.vX' 'cc3.vY' 'cc3.vZ'});
model.result('pg5').feature('str1').set('posmethod', 'uniform');
model.result('pg5').feature('str1').set('udist', 0.03);
model.result('pg5').feature('str1').set('linetype', 'line');
model.result('pg5').feature('str1').set('smooth', 'internal');
model.result('pg5').feature('str1').set('maxlen', Inf);
model.result('pg5').feature('str1').set('maxtime', Inf);
model.result('pg5').feature('str1').set('maxlen', Inf);
model.result('pg5').feature('str1').set('maxtime', Inf);
model.result('pg5').feature('str1').set('maxlen', Inf);
model.result('pg5').feature('str1').set('maxtime', Inf);
model.result('pg5').feature('str1').set('maxlen', Inf);
model.result('pg5').feature('str1').set('maxtime', Inf);
model.result('pg5').feature('str1').set('maxlen', Inf);
model.result('pg5').feature('str1').set('maxtime', Inf);
model.result('pg5').feature('str1').set('data', 'parent');
model.result.create('pg6', 'PlotGroup3D');
model.result('pg6').set('data', 'dset3');
model.result('pg6').label('Coordinate system (cc3)');
model.result('pg6').create('sys1', 'CoordSysVolume');
model.result('pg6').feature('sys1').set('sys', 'cc3_cs');


model.sol.create('sol4');
model.sol('sol4').study('std4');

model.study('std4').feature('stat').set('notlistsolnum', 1);
model.study('std4').feature('stat').set('notsolnum', 'auto');
model.study('std4').feature('stat').set('listsolnum', 1);
model.study('std4').feature('stat').set('solnum', 'auto');

model.sol('sol4').create('st1', 'StudyStep');
model.sol('sol4').feature('st1').set('study', 'std4');
model.sol('sol4').feature('st1').set('studystep', 'stat');
model.sol('sol4').create('v1', 'Variables');
model.sol('sol4').feature('v1').set('control', 'stat');
model.sol('sol4').create('s1', 'Stationary');
model.sol('sol4').feature('s1').create('fc1', 'FullyCoupled');
model.sol('sol4').feature('s1').create('i1', 'Iterative');
model.sol('sol4').feature('s1').feature('i1').set('linsolver', 'cg');
model.sol('sol4').feature('s1').feature('i1').create('mg1', 'Multigrid');
model.sol('sol4').feature('s1').feature('i1').feature('mg1').set('prefun', 'amg');
model.sol('sol4').feature('s1').feature('i1').feature('mg1').set('coarseningmethod', 'classic');
model.sol('sol4').feature('s1').feature('fc1').set('linsolver', 'i1');
model.sol('sol4').feature('s1').feature.remove('fcDef');
model.sol('sol4').attach('std4');

model.result.create('pg7', 'PlotGroup3D');
model.result('pg7').label('Electric Potential (ec)');
model.result('pg7').set('frametype', 'spatial');
model.result('pg7').set('showlegendsmaxmin', true);
model.result('pg7').set('data', 'dset4');
model.result('pg7').feature.create('vol1', 'Volume');
model.result('pg7').feature('vol1').set('showsolutionparams', 'on');
model.result('pg7').feature('vol1').set('solutionparams', 'parent');
model.result('pg7').feature('vol1').set('expr', 'V');
model.result('pg7').feature('vol1').set('colortable', 'Dipole');
model.result('pg7').feature('vol1').set('showsolutionparams', 'on');
model.result('pg7').feature('vol1').set('data', 'parent');
model.result.create('pg8', 'PlotGroup3D');
model.result('pg8').label('Electric Field Norm (ec)');
model.result('pg8').set('frametype', 'spatial');
model.result('pg8').set('showlegendsmaxmin', true);
model.result('pg8').set('data', 'dset4');
model.result('pg8').feature.create('mslc1', 'Multislice');
model.result('pg8').feature('mslc1').set('showsolutionparams', 'on');
model.result('pg8').feature('mslc1').set('solutionparams', 'parent');
model.result('pg8').feature('mslc1').set('expr', 'ec.normE');
model.result('pg8').feature('mslc1').set('multiplanexmethod', 'coord');
model.result('pg8').feature('mslc1').set('xcoord', 'ec.CPx');
model.result('pg8').feature('mslc1').set('multiplaneymethod', 'coord');
model.result('pg8').feature('mslc1').set('ycoord', 'ec.CPy');
model.result('pg8').feature('mslc1').set('multiplanezmethod', 'coord');
model.result('pg8').feature('mslc1').set('zcoord', 'ec.CPz');
model.result('pg8').feature('mslc1').set('colortable', 'Prism');
model.result('pg8').feature('mslc1').set('colortabletrans', 'nonlinear');
model.result('pg8').feature('mslc1').set('colorcalibration', -0.8);
model.result('pg8').feature('mslc1').set('showsolutionparams', 'on');
model.result('pg8').feature('mslc1').set('data', 'parent');
model.result('pg8').feature.create('strmsl1', 'StreamlineMultislice');
model.result('pg8').feature('strmsl1').set('showsolutionparams', 'on');
model.result('pg8').feature('strmsl1').set('solutionparams', 'parent');
model.result('pg8').feature('strmsl1').set('expr', {'ec.Ex' 'ec.Ey' 'ec.Ez'});
model.result('pg8').feature('strmsl1').set('multiplanexmethod', 'coord');
model.result('pg8').feature('strmsl1').set('xcoord', 'ec.CPx');
model.result('pg8').feature('strmsl1').set('multiplaneymethod', 'coord');
model.result('pg8').feature('strmsl1').set('ycoord', 'ec.CPy');
model.result('pg8').feature('strmsl1').set('multiplanezmethod', 'coord');
model.result('pg8').feature('strmsl1').set('zcoord', 'ec.CPz');
model.result('pg8').feature('strmsl1').set('titletype', 'none');
model.result('pg8').feature('strmsl1').set('posmethod', 'uniform');
model.result('pg8').feature('strmsl1').set('udist', 0.02);
model.result('pg8').feature('strmsl1').set('maxlen', 0.4);
model.result('pg8').feature('strmsl1').set('maxtime', Inf);
model.result('pg8').feature('strmsl1').set('inheritcolor', false);
model.result('pg8').feature('strmsl1').set('showsolutionparams', 'on');
model.result('pg8').feature('strmsl1').set('maxtime', Inf);
model.result('pg8').feature('strmsl1').set('showsolutionparams', 'on');
model.result('pg8').feature('strmsl1').set('maxtime', Inf);
model.result('pg8').feature('strmsl1').set('showsolutionparams', 'on');
model.result('pg8').feature('strmsl1').set('maxtime', Inf);
model.result('pg8').feature('strmsl1').set('showsolutionparams', 'on');
model.result('pg8').feature('strmsl1').set('maxtime', Inf);
model.result('pg8').feature('strmsl1').set('data', 'parent');
model.result('pg8').feature('strmsl1').set('inheritplot', 'mslc1');
model.result('pg8').feature('strmsl1').feature.create('col1', 'Color');
model.result('pg8').feature('strmsl1').feature('col1').set('expr', 'ec.normE');
model.result('pg8').feature('strmsl1').feature('col1').set('colortable', 'PrismDark');
model.result('pg8').feature('strmsl1').feature('col1').set('colorlegend', false);
model.result('pg8').feature('strmsl1').feature('col1').set('colortabletrans', 'nonlinear');
model.result('pg8').feature('strmsl1').feature('col1').set('colorcalibration', -0.8);
model.result('pg8').feature('strmsl1').feature.create('filt1', 'Filter');
model.result('pg8').feature('strmsl1').feature('filt1').set('expr', '!isScalingSystemDomain');

model.component('comp1').view('view1').hideEntities.create('hide1');
model.component('comp1').view('view1').hideEntities('hide1').geom(3);
model.component('comp1').view('view1').hideEntities('hide1').add([1 4 8]);

model.sol('sol1').runAll;
model.result('pg1').run;
model.result('pg2').run;
f = figure;
mphplot(model,'pg1');
f.Position = [1,41,1920,963];
f.Children.View = [-16.8946   58.8382];
drawnow
pause(.1)

model.sol('sol2').runAll;
model.result('pg3').run;
model.result('pg4').run;
f = figure;
mphplot(model,'pg3');
f.Position = [1,41,1920,963];
f.Children.View = [62.7874   21.2297];
drawnow
pause(.1)

model.sol('sol3').runAll;
model.result('pg5').run;
model.result('pg6').run;
f = figure;
mphplot(model,'pg5');
f.Position = [1,41,1920,963];
f.Children.View = [-123.3212  -25.8513];
drawnow
pause(.1)

% electrodes1_2 - CC electrode, electrodes1_1 - Posterior 1, electrodes1_3
% - Anterior 1, electrodes1_4 - Anterior 2, electrodes1_5 - Horizontal 1,
% electrodes1_6 - Posterior 2, electrodes1_7 - Horizontal 2
RefElectrodes = [{'electrodes1_2'}];
RefElectrodeNames = [{'CC'}];
StimElectrodes = [{'electrodes1_1'}, {'electrodes1_3'}, {'electrodes1_4'}, {'electrodes1_5'}, {'electrodes1_6'}, {'electrodes1_7'}];
StimElectrodeNames = [{'Posterior1'}, {'Anterior1'}, {'Anterior2'},{'Horizontal1'},{'Posterior2'},{'Horizontal2'}];


%View-Posterior- -1.796443704652980e+02,-78.917368147238932
%CameraPosition -2.263851178121255,22.01258091423081,-109.4993852491663
%0.138486451767768,83.580861013292292
%-2.099179622124298,-12.203111052044948,112.7812814407596
for i = 1:length(RefElectrodes)
    for j = 1:length(StimElectrodes)
        model.component('comp1').physics('ec').feature('pot1').selection.named(['geom1_imp1_',StimElectrodes{j},'_bnd']);
        model.component('comp1').physics('ec').feature('gnd1').selection.named(['geom1_imp1_',RefElectrodes{i},'_bnd']);
        
        model.sol('sol4').runAll;
        model.result('pg7').run;
        model.result('pg8').run;
        f = figure;
        mphplot(model,'pg7');
        f.Position = [1,41,1920,963];
        ax = f.Children;
        if contains(StimElectrodeNames(j),{'Post'})
            ax.View = [-1.796443704652980e+02,-78.917368147238932];
        else
            ax.View = [0.138486451767768,83.580861013292292];
        end
        drawnow
        pause(.1)
        mphsave(model,['R:\Morris, Brian\Computational Modeling\FEM Models\Model as of 20220628\Automation Test 20220705\',StimElectrodeNames{j},'vs',RefElectrodeNames{i},'ref.mph'])
    end
end


out = model;
