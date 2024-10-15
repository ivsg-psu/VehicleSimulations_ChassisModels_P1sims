function DrawVehicle(PosE, PosN, Heading, Delta, a, b, t_f, t_r, r_w)

%Draw line from CG to front axle, CG to rear axle - the "body"

FrontAxle_Center_x = PosE - a*sin(Heading);
FrontAxle_Center_y = PosN + a*cos(Heading);


RearAxle_Center_x = PosE + b*sin(Heading);
RearAxle_Center_y = PosN - b*cos(Heading);

FrontBody = [PosE FrontAxle_Center_x; PosN FrontAxle_Center_y];
RearBody=  [PosE RearAxle_Center_x; PosN RearAxle_Center_y];

plot(PosE, PosN, 'ko', 'MarkerSize', 4)
plot1=plot(FrontBody(1,:), FrontBody(2,:), 'LineWidth', 2.5);
set(plot1(1),'Color',[.8 .8 .8]);
plot1=plot(RearBody(1,:), RearBody(2,:), 'LineWidth', 2.5);
set(plot1(1),'Color',[.8 .8 .8])

%Now draw axles
FrontAxle_Right_x = FrontAxle_Center_x + (t_f/2)*cos(Heading);
FrontAxle_Right_y = FrontAxle_Center_y + (t_f/2)*sin(Heading);

FrontAxle_Left_x = FrontAxle_Center_x - (t_f/2)*cos(Heading);
FrontAxle_Left_y = FrontAxle_Center_y - (t_f/2)*sin(Heading);

RearAxle_Right_x = RearAxle_Center_x + (t_f/2)*cos(Heading);
RearAxle_Right_y = RearAxle_Center_y + (t_f/2)*sin(Heading);

RearAxle_Left_x = RearAxle_Center_x - (t_f/2)*cos(Heading);
RearAxle_Left_y = RearAxle_Center_y - (t_f/2)*sin(Heading);

FrontAxle = [FrontAxle_Left_x FrontAxle_Right_x; FrontAxle_Left_y FrontAxle_Right_y];
RearAxle = [RearAxle_Left_x RearAxle_Right_x; RearAxle_Left_y RearAxle_Right_y];

plot1=plot(FrontAxle(1,:), FrontAxle(2,:), 'LineWidth', 2.5);
set(plot1(1),'Color',[.8 .8 .8])
plot1=plot(RearAxle(1,:), RearAxle(2,:), 'LineWidth', 2.5);
set(plot1(1),'Color',[.8 .8 .8])

%Now draw wheels

RightFrontTire_Front_x = FrontAxle_Right_x - r_w*sin(Heading+Delta);
RightFrontTire_Front_y = FrontAxle_Right_y + r_w*cos(Heading+Delta);

RightFrontTire_Back_x = FrontAxle_Right_x + r_w*sin(Heading+Delta);
RightFrontTire_Back_y = FrontAxle_Right_y - r_w*cos(Heading+Delta);

RightRearTire_Front_x = RearAxle_Right_x - r_w*sin(Heading);
RightRearTire_Front_y = RearAxle_Right_y + r_w*cos(Heading);

RightRearTire_Back_x = RearAxle_Right_x + r_w*sin(Heading);
RightRearTire_Back_y = RearAxle_Right_y - r_w*cos(Heading);

LeftFrontTire_Front_x = FrontAxle_Left_x - r_w*sin(Heading+Delta);
LeftFrontTire_Front_y = FrontAxle_Left_y + r_w*cos(Heading+Delta);

LeftFrontTire_Back_x = FrontAxle_Left_x + r_w*sin(Heading+Delta);
LeftFrontTire_Back_y = FrontAxle_Left_y - r_w*cos(Heading+Delta);

LeftRearTire_Front_x = RearAxle_Left_x - r_w*sin(Heading);
LeftRearTire_Front_y = RearAxle_Left_y + r_w*cos(Heading);

LeftRearTire_Back_x = RearAxle_Left_x + r_w*sin(Heading);
LeftRearTire_Back_y = RearAxle_Left_y - r_w*cos(Heading);


RightFrontTire = [RightFrontTire_Front_x RightFrontTire_Back_x;... 
    RightFrontTire_Front_y RightFrontTire_Back_y];
RightRearTire = [RightRearTire_Front_x RightRearTire_Back_x;... 
    RightRearTire_Front_y RightRearTire_Back_y];
LeftFrontTire = [LeftFrontTire_Front_x LeftFrontTire_Back_x;... 
    LeftFrontTire_Front_y LeftFrontTire_Back_y];
LeftRearTire = [LeftRearTire_Front_x LeftRearTire_Back_x;... 
    LeftRearTire_Front_y LeftRearTire_Back_y];

plot(RightFrontTire(1,:), RightFrontTire(2,:), 'k', 'LineWidth', 3)
plot(RightRearTire(1,:), RightRearTire(2,:), 'k', 'LineWidth', 3)
plot(LeftFrontTire(1,:), LeftFrontTire(2,:), 'k', 'LineWidth', 3)
plot(LeftRearTire(1,:), LeftRearTire(2,:), 'k', 'LineWidth', 3)