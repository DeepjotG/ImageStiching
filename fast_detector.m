function [cornerMatrix, VscoreMatrix] = fast_detector(image)
    [rows, cols] = size(image);
    cornerMatrix = zeros(rows, cols);
    VscoreMatrix = zeros(rows, cols);

    shift_point_1 = imtranslate(image,[0,-3]);
    shift_point_2 = imtranslate(image,[1,-3]);
    shift_point_3 = imtranslate(image,[2,-2]);
    shift_point_4 = imtranslate(image,[3,-1]);
    shift_point_5 = imtranslate(image,[3,0]);
    shift_point_6 = imtranslate(image,[3,1]);
    shift_point_7 = imtranslate(image,[2,2]);
    shift_point_8 = imtranslate(image,[1,3]);
    shift_point_9 = imtranslate(image,[0,3]);
    shift_point_10 = imtranslate(image,[-1,3]);
    shift_point_11 = imtranslate(image,[-2,2]);
    shift_point_12 = imtranslate(image,[-3,1]);
    shift_point_13 = imtranslate(image,[-3,0]);
    shift_point_14 = imtranslate(image,[-3,-1]);
    shift_point_15 = imtranslate(image,[-2,-2]);
    shift_point_16 = imtranslate(image,[-1,-3]);


    shifted_points = {shift_point_1,shift_point_2,...
        shift_point_3,shift_point_4,shift_point_5,...
        shift_point_6,shift_point_7,shift_point_8,...
        shift_point_9,shift_point_10,shift_point_11,...
        shift_point_12,shift_point_13,shift_point_14...
        shift_point_15,shift_point_16};
    total = 0;
    for row = 1:rows
        for col = 1:cols
         total_brighter = 0;
         total_darker = 0;
         for i = 1:numel(shifted_points)
                if image(row, col) + 0.1 <= shifted_points{i}(row, col)
                    total_brighter = total_brighter + 1;
                    total_darker = 0; 
                    if total_brighter >= 12
                        cornerMatrix(row, col) = 1;
                        for j = 1:numel(shifted_points)
                        total = total + abs(image(row, col) - shifted_points{j}(row, col));
                        end
                        VscoreMatrix(row, col) = total;
                        total = 0;
                        break; 
                    end
                elseif image(row, col) - 0.1 >= shifted_points{i}(row, col)
                    total_darker = total_darker + 1;
                    total_brighter = 0; 
                    if total_darker >= 12
                        cornerMatrix(row, col) = 1;
                        for j = 1:numel(shifted_points)
                        total = total + abs(image(row, col) - shifted_points{j}(row, col));
                        end
                        VscoreMatrix(row, col) = total;
                        total = 0;
                        break; 
                    end
                else
                    total_brighter = 0;
                    total_darker = 0;
                end
          end
        end
    end
end