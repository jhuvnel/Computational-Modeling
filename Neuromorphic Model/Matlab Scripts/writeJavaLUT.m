%this function writes a large array into a text file, formatting into a
%style that is usable as a LUT within java (an array initiallizer)

function writeJavaLUT(fileName, mat)
    file = fopen(fileName, 'w');
    fprintf(file, '{');
    for i = 1:size(mat,1)
        fprintf(file, '{');
        iterator = 0;
        for j = 1:size(mat,2)
            fprintf(file, '%12.10f', mat(i,j));
            if (j ~= size(mat,2))
                fprintf(file, ', ');
            end
            iterator = iterator + 1;
            if (iterator == 4)
                iterator = 0;
                fprintf(file, '\n');
            end
        end
        if (i ~= size(mat,1))
            fprintf(file, '}, \n');
        else
            fprintf(file, '}');
        end
    end
    fprintf(file, '};');
    fclose(file);