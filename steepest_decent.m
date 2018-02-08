 function [x, f, grad, s, a_star, n_objectives] = steepest_decent(f, grad, x, alpha, obj, gradobj, plot_bool, s)

    s(:,end+1) = -grad(:,end);   % search direction
    mag = sqrt(grad(:,end)'*grad(:,end)); % magnitude

    f_a(1) = f(:,end);
    
    % FIRST STEP
    a(2) = alpha;
    x_n = x(:,end) + a(2)*s(:,end)/mag;
    f_a(2) = obj(x_n);
    
    n_objectives = 1;

    if plot_bool
%         plot(x_n(1), x_n(2), 'r.');
    end

    % Iterator Variables
    i = 3;
    not_passed_min = true;
    not_done = true;

    while not_done

        % Decide to step forward or backward
        if not_passed_min == false
            a(i) = a(i-1)/2;
        elseif f_a(i-1) < f_a(i-2)
            a(i) = a(i-1)*2;
        else
            a(i) = a(i-1)*3/4;
            not_passed_min = false;
        end

        [val, min_ind] = min(f_a);

        % Determine if ready for quad
        if not_passed_min == false && min_ind ~= 1
            not_done = false;
        end

        % set point
        x_n = x(:,end) + a(i)*s(:,end)/mag;
        f_a(i) = obj(x_n);
        
        n_objectives = n_objectives + 1;

        % Iteration funcs
        if plot_bool
%             plot(x_n(1), x_n(2), 'r.');
        end

        i = i + 1;

    end

    % Set values to calc a_star
    a_star = parabolic_line_search(a, f_a);
    
    x(:,end+1) = x(:,end) + a_star*s(:,end)/mag;
    f(:,end+1) = obj(x(:,end));
    grad(:,end+1) = gradobj(x(:,end));
    
    n_objectives = n_objectives + 1;

 end