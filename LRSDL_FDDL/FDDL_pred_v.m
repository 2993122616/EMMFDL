function [pred1,pred2,pred3,pred4] = FDDL_pred_v(Y,Yv, D,Dv, CoefM, opts) % GC
    vgamma = opts.gamma;
    opts.max_iter = 100;
    [X, ~] = lasso_fista(Y, D, zeros(size(D,2), size(Y,2)), vgamma, opts);
    [Xv, ~] = lasso_fista(Yv, Dv, zeros(size(Dv,2), size(Yv,2)), vgamma, opts);
    C = size(CoefM,2);%相当于几类
    w = 0.5;
    E_1 = zeros(C, size(Y,2));%几类，测试样本共有多少类
    E_2 = zeros(C, size(Y,2));
    E_3 = zeros(C, size(Y,2));
    E_4 = zeros(C, size(Y,2));
    for c = 1: C 
       Dc = get_block_col(D, c, opts.D_range);%维数*源数据每类训练数
        Xc = get_block_row(X, c, opts.D_range);%源数据每类训练数*一共测试数据
        R1 = Y - Dc*Xc;
        E1 = sum(R1.^2);
        
        Dcv = get_block_col(Dv, c, opts.D_range);
        Xcv = get_block_row(Xv, c, opts.D_range);
        R1v = Yv - Dcv*Xcv;
        E1v = sum(R1v.^2);
        
        sorted_E1=sort(E1);
        sorted_E1v=sort(E1v);
        %canshu1=sum(sorted_E1(1:2))/sum(sorted_E1);
        %canshu2=sum(sorted_E1v(1:2))/sum(sorted_E1v);
        canshu1=sorted_E1(2)-sorted_E1(1);
        canshu2=sorted_E1v(2)-sorted_E1v(1);
        f1=canshu1/(canshu1+canshu2);
        f2=1-f1;
        f3=(1-f1)/2;
        
        R2 = X - repmat(CoefM(:, c), 1, size(Y,2));
        E2 = sum(R2.^2);

 
        %E(c,:) = E1+opts.weight*E2;
        E_1(c,:)=E1;
        E_2(c,:)=E1v;
        E_3(c,:) = f1*E1+f2*E1v;
        E_4(c,:) = f1*E1+f2*E1v+opts.weight*E2;;
    end 
    [~, pred1] = min(E_1);
    [~, pred2] = min(E_2);
    [~, pred3] = min(E_3);
    [~, pred4] = min(E_4);
end 