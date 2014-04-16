% This file was created to generate the table for the webpage for each of
% the gulf of the mexico region.
% Nabin Malakar
% OCt 13, 2011
 
 
txt='tablePrint';
file_name = [txt '.txt'];
fid1  =fopen(file_name,'w'); % the front page with pie and class
stringP=' <table id="room"> <tr><th  COLSPAN=3><H1>Summary Page</H1> </th></tr><tr class="alt">  <td COLSPAN=3> We Compare the PDF for 2006, 2007 and 2008 to illustrate the different nature of distributions. <br />  </tr>'
fprintf(fid1,'%s', stringP);

  combinations = combnk([1:7],2);   
 namestr = {'stPM', 'AOD', 'PBL', 'PR', 'RH', 'TE', 'WI'};
   
   fprintf(fid1,'   <tr> <th  COLSPAN=3> %s </th> </tr><tr> ', 'Compare the PDFs'  );

 
    for  jj=1:length(combinations)
    
    xlabelname = namestr{combinations(jj,1)};
    ylabelname = namestr{combinations(jj,2)};
    
  
%     end
  
    
    
  figname6 = [ xlabelname, '-', ylabelname,   '2006.png'];
  figname7 = [ xlabelname, '-', ylabelname,   '2007.png'];
  figname8 = [ xlabelname, '-', ylabelname,   '2008.png'];
% <img src="smiley.gif"  width="42" height="42">
          fprintf(fid1, '<td> <center> <img src="%s" width="300" height="300"> <br/><a href="%s">pngImage </a>  </td> <td> <center>  <img src="%s" width="300" height="300"> <br/><a href="%s">pngImage</a>  </td> <td>  <center> <img src="%s" width="300" height="300"> <br/><a href="%s">pngImage</a>  </td> </tr> <tr>', figname6,figname6,figname7,figname7,figname8,figname8   );
    end
  
%     for class= 1:20
%  
%         fprintf(fid1, '<td>   %s </a>  </td> ', ['cell #' num2str(class)]  );
%         
%         
%         if  rem(class,3)==0
%             fprintf(fid1,'</tr> <tr>');
%         end
%     end
    
     
 
  
fprintf(fid1, '</table> </body></html>')
 
fclose(fid1);

% these commands concatenate the files    to create html
icommand =  ['cat onetext.txt  ', file_name, '>', 'results.htm'];
status = system(icommand);
