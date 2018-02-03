 function [xopt, fopt, exitflag] = fminun(obj, gradobj, x0, stoptol, algoflag, alpha, num_plot)
             
        %initialize variables
        f = obj(x0);          %objective function
        grad = gradobj(x0);   %gradient
        x = x0;               %design
        
        % loop parameters
        iter = 0;          % iteration number
        max_iter = 100;    % maximum number of iterations
        plot_bool = true;
                
        while (iter<max_iter && all((abs(grad(:))) > stoptol))
             
            if iter < num_plot
                plot(x(1),x(2),'-wp');
            else
                plot_bool = false;
            end
            
            if (algoflag == 1)     % steepest descent
                [s, a_star, mag] = steepest_decent(f, grad, x, alpha, obj, plot_bool);        
            elseif (algoflag == 2) % conjugate gradient
                s = srchsd(grad);
            else                   % BFGS quasi newtown
                s = srchsd(grad);  
            end
            
            % take a step
            x = x + a_star*s/mag;
            f = obj(x);
            grad = gradobj(x);
            
            iter = iter + 1;
            
        end
        
        xopt = x;
        fopt = f;
        exitflag = 0;
        iter
        
     end
     
     % get steepest descent search direction as column vector and step size
     % as a scalar
     function [s, a_star, mag] = steepest_decent(f, grad, x, alpha, obj, plot_bool)
        
        s = -grad;   % search direction
        mag = sqrt(grad'*grad); % magnitude
                
        f_a(1) = f;
        
        % FIRST STEP
        a(2) = alpha;
        x_n = x + a(2)*s/mag;
        f_a(2) = obj(x_n);
        
        if plot_bool
            plot(x_n(1), x_n(2), '--r*');
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
            x_n = x + a(i)*s/mag;
            f_a(i) = obj(x_n);
            
            % Iteration funcs
            if plot_bool
                plot(x_n(1), x_n(2), 'r*');
            end
            
            i = i + 1;
            
        end
        
        % Set values to calc a_star
        [val, index2] = min(f_a);
        a_2 = a(index2);
        f_2 = f_a(index2);
        
        a_less = a;
        a_less(a_less<=a_2)=Inf;
        [val, index3] = min(a_less);
        a_3 = a(index3);
        f_3 = f_a(index3);
        
        a_more = a;
        a_more(a_more>=a_2)=0;
        [val, index1] = max(a_more);
        a_1 = a(index1);
        f_1 = f_a(index1);
        
        a_star = (f_1*(a_2^2-a_3^2)+f_2*(a_3^2-a_1^2)+f_3*(a_1^2-a_2^2))/(2*(f_1*(a_2-a_3)+f_2*(a_3-a_1)+f_3*(a_1-a_2)));
        
     end