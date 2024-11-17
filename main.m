clear; clc; close all
%Ŀ�꺯��Solving (D, X) = \arg\min_{D,X} ||Y - DX||_F^2 + lambda||X||_1+alphaTr(DUD')+betaTr(X'UX)+Tr(XZX')
 m=0;%ÿ����������
 c=40;%����������
 train_num=5;%ÿ��ѵ�������ĸ���
addpath(genpath('.\ksvdbox'));  %���K-SVD box·��
addpath(genpath('.\OMPbox')); % add sparse coding algorithem OMP������ƥ��׷���㷨��
sparsitythres = 30; % sparsity prior��ϡ����ֵT0=30��
iterations4ini=1; % ������
addpath('ODL');%Solving (D, X) = \arg\min_{D,X} 0.5||Y - DX||_F^2 + lambda||X||_1
addpath('LRSDL_FDDL');%LRSDL�����ض���DDL�㷨��FDDL�ض���DDL�㷨
addpath('utils');
max_iter=30;%��������30

miu=127;
sigma=40;

for jj=1%:10%
sumd=0; 
sumd1=0; 
     for p=1:20
     %��ȡѵ�����ݺͲ�������
     [train_data,train_data_v,train_label,test_data,test_data_v,test_label]=read_datav_ORL(train_num,m,c,miu,sigma);
     % %��ǩ����
     clear H_train H_test
     H_train =lcksvd_buildH(train_label);%ѵ�������ı�ǩ����
     
     H_test= lcksvd_buildH(test_label);%���������ı�ǩ����
     
        for dictsize=200% �ֵ���=ѵ����
        sumd=sumd+1;
        % clear Dinit%�ֵ��ʼ��%
        [Dinit,Tinit,Cinit,Q_train,Xinit,D_label] = initialization4LCKSVD(train_data,H_train,dictsize,iterations4ini,sparsitythres);
        
        [Dvinit,Tvinit,Cvinit,Qv_train,Xvinit,Dv_label] = initialization4LCKSVD(train_data_v,H_train,dictsize,iterations4ini,sparsitythres);
        %������ѵ��������ʼ���ֵ�
        PA=[1e-5,1e-4,1e-3,1e-2,1e-1,1,0,10,100,1e+3,1e+4,1e+5];%����alpha,beta,gam
            for alpha1=1%1:6 %
                for beta1=1%1:6%
                    for gam1=4%1:6%4
                        for gams1=6%1:6%
                        alpha=PA(alpha1);
                        beta=PA(beta1);
                        gam=PA(gam1);
                        gams=PA(gams1);
                        
                        Y_range = label_to_range(train_label);%�ֳ�10�飬ÿ����  ��
                        D_range = (dictsize/c)*(0:c);
                        [Q]=construct_Q(D_label);
                        [Qv]=construct_Q(Dv_label);
                        U=(eye(dictsize)+(1/dictsize)*ones(dictsize,dictsize)-2*Q);
                        Uv=(eye(dictsize)+(1/dictsize)*ones(dictsize,dictsize)-2*Qv);
                        
                        % % ѧϰ�ֵ�
                        [D,X,obj] = Learn_D_X(train_data,Dinit,Xinit,alpha,beta,gam,gams,max_iter,U,Y_range); %��ѵ������ѧϰ�õ��ֵ�ͱ���ϵ���ĺ���
                        [Dv,Xv,objv] = Learn_D_X(train_data_v,Dvinit,Xvinit,alpha,beta,gam,gams,max_iter,Uv,Y_range);
                        % % Mean vectors
                        CoefM = zeros(size(X, 1), c);
                            for i = 1: c
                            Xc = get_block_col(X, i, Y_range);
                            CoefM(:, i) = mean(Xc,2);
                            end
                        
                        % clasification  ����
                        fprintf('GC:\n');
                        opts.verbose = 0;
                        opts.weight = 0.5;
                        opts.D_range = D_range;
                        acc1 = [];
                        acc2 = [];
                        acc3 = [];
                        acc4 = [];
                        
                            for vgamma = [0.0001, 0.001, 0.01, 0.1]%vgamma�ֱ�������ĸ�ֵ��ʶ���ʷ������
                            opts.gamma = vgamma;
                            [pred1,pred2,pred3,pred4] = FDDL_pred_v(test_data,test_data_v, D,Dv, CoefM, opts);%predict
                            acc1 = [acc1 calc_acc(pred1, test_label')];
                            acc2 = [acc2 calc_acc(pred2, test_label')];
                            acc3 = [acc3 calc_acc(pred3, test_label')];
                            acc4 = [acc4 calc_acc(pred4, test_label')];
                            %fprintf('vgamma = %.4f, acc = %.4f\n', vgamma, acc(end));
                            end
                            
                        acc1(p)= max(acc1);%��¼10�ε�׼ȷ��
                        acc2(p)= max(acc2);
                        acc3(p)= max(acc3);
                        acc4(p)= max(acc4);
                        b=fopen('ceshi.txt','a+'); %���ÿ�β��Ե�ʶ����
                        fprintf(b,'%d,%d,%d,%d,%d,%.03f\r\n',dictsize,alpha1,beta1,gam1,gams1,acc1);
                        fclose(b);
                            
                        end
                    end
                end
            end
        end
     rec1(jj,sumd)=acc1(p);
     rec2(jj,sumd)=acc2(p);
     rec3(jj,sumd)=acc3(p);
     rec4(jj,sumd)=acc4(p);
     fprintf('1=%f,2=%f,3=%f,4=%f\n',acc1(p),acc2(p),acc3(p),acc4(p));
     end
end

ave_acc1=mean(rec1);%ƽ��ʶ����
ave_acc2=mean(rec2);
ave_acc3=mean(rec3);
ave_acc4=mean(rec4);
%ave_acc_1=rec.*100;
%sigm=sqrt(mean(ave_acc_1.^2)-mean(ave_acc_1)^2)/sqrt(10);

%fprintf('ave_acc=%.4f,sigm=%.2f\n',ave_acc,sigm);
fprintf('ave_acc1=%.4f,ave_acc2=%.4f,ave_acc3=%.4f,ave_acc4=%.4f\n',ave_acc1,ave_acc2,ave_acc3,ave_acc4);
fprintf('err=%.4f\n',1-ave_acc4);