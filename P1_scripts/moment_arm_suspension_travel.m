% JH 3/1/06
% simulating suspension travel and seeing its affects
% during a turning manever on the effective moment arm between
% the motor and the tie rod (of left side)

close all; clear all; clc;
% load all of carrie's adams data
load suspension_data
% look at RH ramp steer maneuver
load('TestData/Judy_2005-08-30_ab.mat')

% names
p1_params
% run look up tables
nissan_steer_lookup_data
% get post-processed data
postprocess

% Raw ADAMS data relating steer motor angle to toe angle and tie rod (0mm
% suspension height)
% locations on left wheel (negative signs correct sign convention to ISO).
motor_angle = -(pi/180)*[-43.00	-42.14	-41.28	-40.42	-39.56	-38.70	-37.84	-36.98	-36.12	-35.26	-34.40	-33.54	-32.68	-31.82	-30.96	-30.10	-29.24	-28.38	-27.52	-26.66	-25.80	-24.94	-24.08	-23.22	-22.36	-21.50	-20.64	-19.78	-18.92	-18.06	-17.20	-16.34	-15.48	-14.62	-13.76	-12.90	-12.04	-11.18	-10.32	-9.46	-8.60	-7.74	-6.88	-6.02	-5.16	-4.30	-3.44	-2.58	-1.72	-0.86	0.00	0.86	1.72	2.58	3.44	4.30	5.16	6.02	6.88	7.74	8.60	9.46	10.32	11.18	12.04	12.90	13.76	14.62	15.48	16.34	17.20	18.06	18.92	19.78	20.64	21.50	22.36	23.22	24.08	24.94	25.80	26.66	27.52	28.38	29.24	30.10	30.96	31.82	32.68	33.54	34.40	35.26	36.12	36.98	37.84	38.70	39.56	40.42	41.28	42.14	43.00];
ibj_x = -(1/1000)*[-93.44263	-95.48945	-97.52254	-99.54159	-101.5463	-103.5351	-105.5089	-107.467	-109.4081	-111.3317	-113.2383	-115.1275	-116.9978	-118.8506	-120.6833	-122.4964	-124.2904	-126.0636	-127.8165	-129.5483	-131.2586	-132.9466	-134.6126	-136.2561	-137.8763	-139.4736	-141.0472	-142.5965	-144.1207	-145.621	-147.0959	-148.5465	-149.9701	-151.3679	-152.7392	-154.0842	-155.4012	-156.6923	-157.9549	-159.1901	-160.3962	-161.5753	-162.7248	-163.8457	-164.9374	-165.999	-167.0316	-168.0337	-169.0063	-169.9487	-170.86	-171.7405	-172.5904	-173.409	-174.1963	-174.9517	-175.6754	-176.3676	-177.0275	-177.6554	-178.2515	-178.8141	-179.3444	-179.8427	-180.3073	-180.7404	-181.1394	-181.5055	-181.8381	-182.1375	-182.404	-182.6371	-182.8361	-183.0024	-183.1345	-183.2339	-183.2988	-183.3312	-183.3291	-183.2936	-183.225	-183.1224	-182.986	-182.817	-182.6133	-182.3769	-182.1078	-181.804	-181.4682	-181.0978	-180.6954	-180.2598	-179.7915	-179.2897	-178.7565	-178.1891	-177.5905	-176.9595	-176.2959	-175.5997	-174.8726]';
ibj_y = -(1/1000)*[-387.136	-386.2325	-385.2975	-384.3328	-383.3372	-382.3127	-381.2572	-380.1734	-379.0595	-377.9161	-376.7453	-375.5449	-374.317	-373.0604	-371.7772	-370.4661	-369.1273	-367.7626	-366.3711	-364.9535	-363.5101	-362.0417	-360.5473	-359.0288	-357.4853	-355.9178	-354.3262	-352.7115	-351.0737	-349.4128	-347.7298	-346.0246	-344.2984	-342.551	-340.7826	-338.9939	-337.1852	-335.3564	-333.5094	-331.6433	-329.7582	-327.8559	-325.9355	-323.999	-322.0455	-320.0759	-318.0902	-316.0894	-314.0736	-312.0438	-310	-307.9432	-305.8724	-303.7896	-301.6948	-299.5881	-297.4705	-295.343	-293.2046	-291.0564	-288.8992	-286.7334	-284.5597	-282.3773	-280.1881	-277.9932	-275.7907	-273.5827	-271.3699	-269.1527	-266.9301	-264.7049	-262.4754	-260.2437	-258.0107	-255.7745	-253.5381	-251.2998	-249.0626	-246.8246	-244.5879	-242.3528	-240.1181	-237.8873	-235.6583	-233.4336	-231.2112	-228.9944	-226.7817	-224.5749	-222.3731	-220.1781	-217.9897	-215.8096	-213.6362	-211.4705	-209.3145	-207.1673	-205.0304	-202.9038	-200.7875]';
ibj_z =  (1/1000)*[268.0006	268.0004	268.0003	268.0003	268.0005	268.0009	268.0003	267.9999	267.9996	267.9994	267.9994	268.0005	268.0006	268.0009	268.0013	268.0008	268.0004	267.999	267.9998	268.0007	267.9996	267.9996	268.0008	268.0009	267.9992	267.9985	267.9999	268.0004	268	268.0006	267.9992	267.9999	267.9997	267.9995	267.9994	267.9993	267.9993	267.9993	267.9993	268.0004	267.9995	267.9996	268.0008	267.9999	268.0001	268.0003	268.0006	267.9998	268	267.9993	268.0005	268.0008	268.001	268.0002	268.0015	267.9997	268.0009	267.999	267.9992	268.0004	267.9995	268.0006	267.9996	267.9996	268.0006	267.9996	267.9995	267.9993	267.9991	267.9999	268.0007	267.9993	267.9989	268.0005	268.001	268.0004	268.0007	267.999	268.0003	267.9994	267.9995	268.0005	267.9994	268.0003	268.0001	267.9998	268.0004	267.9989	268.0014	267.9997	268.001	267.9991	267.9992	268.0002	267.999	267.9988	267.9995	267.9991	267.9995	267.9999	268.0012]';
obj_x = -(1/1000)*[-110.0414	-110.8205	-111.6195	-112.4364	-113.2697	-114.1169	-114.9771	-115.849	-116.7299	-117.6183	-118.5137	-119.4145	-120.3182	-121.2254	-122.1327	-123.0396	-123.9456	-124.8484	-125.7475	-126.6417	-127.5294	-128.4094	-129.2814	-130.1439	-130.9957	-131.8364	-132.6648	-133.4795	-134.2793	-135.065	-135.8341	-136.5875	-137.3219	-138.0381	-138.7348	-139.4118	-140.0668	-140.7017	-141.3131	-141.9019	-142.4658	-143.0067	-143.5212	-144.0103	-144.4726	-144.907	-145.3144	-145.6923	-146.0417	-146.3613	-146.65	-146.9075	-147.1336	-147.327	-147.4877	-147.6143	-147.7066	-147.7644	-147.7865	-147.7726	-147.7225	-147.6339	-147.5076	-147.3433	-147.1387	-146.8956	-146.6106	-146.2845	-145.9159	-145.5045	-145.05	-144.5509	-144.0059	-143.4156	-142.7775	-142.0921	-141.3572	-140.5728	-139.7369	-138.8484	-137.907	-136.9096	-135.856	-134.745	-133.5727	-132.3391	-131.0422	-129.678	-128.2458	-126.7402	-125.1606	-123.5022	-121.7605	-119.9303	-118.0075	-115.9829	-113.8515	-111.6025	-109.2241	-106.7023	-104.0214]';
obj_y = -(1/1000)*[-796.086	-795.2435	-794.3645	-793.4512	-792.5028	-791.5213	-790.5048	-789.4566	-788.3745	-787.2599	-786.1147	-784.9371	-783.729	-782.4896	-781.2208	-779.9219	-778.5927	-777.2354	-775.8489	-774.4345	-772.9919	-771.5223	-770.0247	-768.5012	-766.9507	-765.3742	-763.7718	-762.1445	-760.4923	-758.8152	-757.1142	-755.3894	-753.6416	-751.871	-750.0774	-748.2621	-746.4248	-744.5656	-742.6866	-740.7867	-738.8658	-736.9261	-734.9665	-732.989	-730.9925	-728.9781	-726.9458	-724.8966	-722.8304	-720.7482	-718.65	-716.5368	-714.4076	-712.2644	-710.1072	-707.9359	-705.7515	-703.555	-701.3454	-699.1236	-696.8908	-694.6466	-692.3923	-690.1267	-687.8519	-685.5688	-683.2753	-680.9733	-678.6641	-676.3473	-674.0219	-671.6911	-669.3526	-667.0083	-664.6593	-662.3035	-659.9439	-657.5782	-655.2094	-652.8354	-650.4581	-648.0772	-645.6919	-643.3047	-640.9137	-638.5204	-636.1228	-633.7236	-631.3203	-628.9151	-626.5049	-624.0919	-621.6743	-619.2524	-616.8238	-614.3875	-611.9435	-609.4887	-607.0216	-604.5382	-602.0345]';
obj_z =  (1/1000)*[282.3874	282.0556	281.7117	281.3557	280.9875	280.6071	280.2177	279.8161	279.4064	278.9846	278.5546	278.1135	277.6634	277.2051	276.7387	276.2632	275.7796	275.291	274.7922	274.2853	273.7724	273.2524	272.7252	272.1931	271.6548	271.1095	270.5581	270.0016	269.44	268.8714	268.3008	267.7241	267.1423	266.5565	265.9666	265.3727	264.7747	264.1727	263.5667	262.9576	262.3465	261.7324	261.1152	260.4961	259.8739	259.2477	258.6214	257.9942	257.364	256.7327	256.0995	255.4652	254.831	254.1958	253.5585	252.9223	252.2851	251.649	251.0108	250.3736	249.7385	249.1014	248.4664	247.8324	247.1994	246.5684	245.9385	245.3087	244.6829	244.0581	243.4333	242.8147	242.1971	241.5815	240.969	240.3596	239.7553	239.153	238.5537	237.9606	237.3685	236.7815	236.2006	235.6217	235.0499	234.4822	233.9196	233.3631	232.8106	232.2663	231.725	231.1929	230.6668	230.1458	229.635	229.1292	228.6325	228.1429	227.6625	227.1901	226.7268]';

% arbtrarily model suspension height as a fxn of steer angle
delta0 = (pi/180)*3;  % upper limit for steer angle with 0 suspension travel
delta25 = (pi/180)*6; % upper limit for steer angle with 25 mm suspension travel

% go thru each steering angle and determine which IBJ/OBJ location to use
ibjx = zeros(length(motor_angle),1);
ibjy = zeros(length(motor_angle),1);
ibjz = zeros(length(motor_angle),1);
objx = zeros(length(motor_angle),1);
objy = zeros(length(motor_angle),1);
objz = zeros(length(motor_angle),1);
for i = 1:length(motor_angle)
    % steering angle < delta0, so set suspension height = 0
    if abs(motor_angle(i)) < delta0
        ibjx(i) = ibj_x(i);
        ibjy(i) = ibj_y(i); 
        ibjz(i) = ibj_z(i);
        objx(i) = obj_x(i);
        objy(i) = obj_y(i); 
        objz(i) = obj_z(i); 
    % steering angle in [delta0, delta25] (LH turn), so set suspension height = +25
    elseif motor_angle(i) >= delta0 & motor_angle(i) <= delta25
        ibjx(i) = -(1/1000)*ibj_x_25(i);
        ibjy(i) = -(1/1000)*ibj_y_25(i); 
        ibjz(i) = (1/1000)*ibj_z_25(i);
        objx(i) = -(1/1000)*obj_x_25(i);
        objy(i) = -(1/1000)*obj_y_25(i); 
        objz(i) = (1/1000)*obj_z_25(i);
    % steering angle > delta25 (LH turn), so set suspension height = +50
    elseif motor_angle(i) > delta25
        ibjx(i) = -(1/1000)*ibj_x_50(i);
        ibjy(i) = -(1/1000)*ibj_y_50(i); 
        ibjz(i) = (1/1000)*ibj_z_50(i);
        objx(i) = -(1/1000)*obj_x_50(i);
        objy(i) = -(1/1000)*obj_y_50(i); 
        objz(i) = (1/1000)*obj_z_50(i);
    % steering angle in [-delta0, -delta_25] (RH turn), so set suspension height = -25
    elseif motor_angle(i) <= -delta0 & motor_angle(i) >= -delta25
        ibjx(i) = -(1/1000)*ibj_x_neg25(i);
        ibjy(i) = -(1/1000)*ibj_y_neg25(i); 
        ibjz(i) = (1/1000)*ibj_z_neg25(i);
        objx(i) = -(1/1000)*obj_x_neg25(i);
        objy(i) = -(1/1000)*obj_y_neg25(i); 
        objz(i) = (1/1000)*obj_z_neg25(i);
    % steering angle < -delta25 (RH turn), so set suspension height = -50
    else 
        ibjx(i) = -(1/1000)*ibj_x_neg50(i);
        ibjy(i) = -(1/1000)*ibj_y_neg50(i); 
        ibjz(i) = (1/1000)*ibj_z_neg50(i);
        objx(i) = -(1/1000)*obj_x_neg50(i);
        objy(i) = -(1/1000)*obj_y_neg50(i); 
        objz(i) = (1/1000)*obj_z_neg50(i);
    end
end

pitman_x = -(1/1000)*(-34.24);
pitman_y = -(1/1000)*(-250.3);
pitman_z =  (1/1000)*268;
% Obtain load cell and steering torque relationships
pitman_length = sqrt((pitman_x - ibj_x(1))^2 + (pitman_y - ibj_y(1))^2 + (pitman_z - ibj_z(1))^2);
tierod_length = sqrt((obj_x(1) - ibj_x(1))^2 + (obj_y(1) - ibj_y(1))^2 + (obj_z(1) - ibj_z(1))^2);

% Get the final gain... in units of length between steer axis torque and load cell force
torque_cell_arm_length = -((ibj_x-obj_x).*(ibj_y-pitman_y) - (ibj_x-pitman_x).*(ibj_y-obj_y)) / tierod_length;   % this is between MOTOR axis torque and load cell force
torque_cell_arm_length1 = -((ibjx-objx).*(ibjy-pitman_y) - (ibjx-pitman_x).*(ibjy-objy)) / tierod_length;   % recalculate moment arm adjusted for suspension travel
sglu.fl.lc = sglu.fl.lr .* torque_cell_arm_length'; % this one goes between STEER axis torque and load cell force (m)
sglu.fr.lc = sglu.fr.lr .* -torque_cell_arm_length(end:-1:1)'; % this one goes between STEER axis torque and load cell force (m)
sglu.fl.lc1 = sglu.fl.lr .* torque_cell_arm_length1'; % recalculate with torque_cell_arm_length1
sglu.fr.lc1 = sglu.fr.lr .* -torque_cell_arm_length1(end:-1:1)'; % recalculate with torque_cell_arm_length1

% figure; plot(motor_angle,[torque_cell_arm_length torque_cell_arm_length1])
% figure; plot(motor_angle,[obj_y objy -(1/1000)*obj_y_25 -(1/1000)*obj_y_50 -(1/1000)*obj_y_neg25 -(1/1000)*obj_y_neg50]);

tstart = 0; 
tend =  t(end); 
T = tstart*500+1:tend*500+1;
t = t(T) - tstart;
% calc average steering angle
deltaL = PostProc(:,1);
deltaR = PostProc(:,2);
delta = (deltaL + deltaR)/2;
delta = delta(T);

% compare motor steering torque vs. load cell force*moment arm
% motor steering torque
motortorque = Commands(T,1).*kM*gr*eff;
% load cell torque (no suspension travel)
lctorque = interp1(sglu.fl.ma,sglu.fl.lc,Steering(T,1)/param.fl.gr) .* Load_Cells(T,1);
% load cell torque with suspension travel
lctorque1 = interp1(sglu.fl.ma,sglu.fl.lc1,Steering(T,1)/param.fl.gr) .* Load_Cells(T,1);
% are the gains much different? not really:
figure; plot(motor_angle,[sglu.fl.lc1; sglu.fl.lc])
% so motor torque and lctorque still don't quite line up
figure; plot(t,[motortorque lctorque lctorque1])
legend('commanded motor torque','LC torque','LC torque adjusted for suspension travel')
        