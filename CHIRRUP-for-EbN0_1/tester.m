addpath("utils")
r = 0
l = 0
re = 0

EbN0 = 0
trials = 10


prop=1
mvalues=[8] % 8 7
pvalues=[6] % 6 7

for a = 1:size(mvalues, 2)
    m=mvalues(a);
    
    for b=1:size(pvalues,2)
        p=pvalues(b);
        
        disp('m')
        disp(m)
        disp('p')
        disp(p)
        output=[];
        K=[] ;
        time=[];
        prop=1;
        EbN0_list=[];
        
        start_K = 40; %40  40
        last_K = 160; %160  220
        diff_K = 20; %20  20

        start_EbN0 = 4; %6  5
        last_EbN0 = 14; %12  14
        diff_EbN0 = 0.2; % 0.2  0.2
        
        epsilon = 0.95;
        
        ebn0_last = 0;
        flag = 0;
        
        for i=start_K:diff_K:last_K
            K=[K, i];
            disp(i)
            for ebn0=start_EbN0:diff_EbN0:last_EbN0
%                 EbN0は the smallest で 0.95ってことか．
                [prop, ave_time, flag] = run(r, l, re, m, p, ebn0, i, trials, epsilon);
                if (flag == 1)
                    disp(["flag : 1","EbN0",ebn0])
                    continue;
                end
%                  if (prop < epsilon) % ここ逆？
% %                  if (flag == 0)
%                      ebn0_last = ebn0;
%                      break;
%                  end
                disp(["ebn0",ebn0])
                ebn0_last = ebn0;
            end
            output = [output, prop];
            time = [time, ave_time];
            disp(["prop",prop])
            disp(["EbN0",ebn0_last])
            EbN0_list = [EbN0_list, ebn0_last];
        end
        
        B = 1
        filename=strcat("tests/B", num2str(B),'r', num2str(r),'l', num2str(l),'r', num2str(r),'m', num2str(m),'p', num2str(p), 'trials', num2str(trials))
        save(filename, "K", "output", "time");
    end
end

for i=1:size(K,2)
    disp(["K",K(i),"EbN0",EbN0_list(i)]);
end


x=strcat("tests/B", num2str(B),'r', num2str(r),'l', num2str(l),'r', num2str(r),'m', num2str(m),'p', num2str(p), 'trials', num2str(trials))
x(1)
% plot(K, output)
% xlabel('K')
% ylabel('prop found')
plot(K, EbN0_list)
xlabel('K')
ylabel('EbN0(dB)')