module  ClkDiv (
    input wire i_ref_clk ,
    input wire i_rst_n ,
    input wire i_clk_en ,
    input wire [7:0] i_div_ratio ,
    output reg o_div_clk
);  
    // clk_div
    reg clk_div ;
    reg clk_odd_div ;

    
    // counter edges
    reg [7:0] count_positive ; 
    reg [7:0] count_negative ;       

    // enable
    wire enable ;
    assign enable = i_clk_en && ( i_div_ratio != 0) && ( i_div_ratio != 1) ; 

    // even logic
    wire is_even ;
    assign is_even = ~ i_div_ratio[0] ;
  
    always @(posedge i_ref_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            clk_div <= 0 ;
            count_positive <= 0 ;            
        end

        else if (enable) begin
            if (is_even) begin
                if(count_positive == (i_div_ratio >> 1)) begin
                    clk_div <= ~ clk_div ;
                    count_positive <= 1 ;
                end
                else begin
                    count_positive <= count_positive + 1 ;
                end
            end 
            else begin
                if (count_positive == 0) begin
                    clk_div <= ~ clk_div ;
                    count_positive <= count_positive + 1 ;
                end
                else if(count_positive == (i_div_ratio >> 1)) begin
                    clk_div <= ~ clk_div ;
                    count_positive <= count_positive + 1 ;
                end
                else if(count_positive == (i_div_ratio - 1)) begin
                    count_positive <= 0 ;
                end                    
                else begin
                    count_positive <= count_positive + 1 ;
                end                
            end
        end  
        else begin
            clk_div <= 0 ;
            count_positive <= 0 ; 
        end   
    end

always @(negedge i_ref_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            clk_odd_div <= 0 ;
            count_negative <= 0 ;           
        end

        else if (enable && !(is_even)) begin
                if (count_negative == 0) begin
                    clk_odd_div <= ~ clk_odd_div ;
                    count_negative <= count_negative + 1 ;
                end
                else if(count_negative == (i_div_ratio >> 1)) begin
                    clk_odd_div <= ~ clk_odd_div ;
                    count_negative <= count_negative + 1 ;
                end
                else if(count_negative == (i_div_ratio - 1)) begin
                    count_negative <= 0 ; 
                end                                   
                else begin
                    count_negative <= count_negative + 1 ;
                end                
            end 
        else begin
            clk_odd_div <= 0 ;
            count_negative <= 0 ;
        end   
    end            

always @(*) begin
    if(enable) begin
        if(is_even) begin
            o_div_clk = clk_div ; // even divide
        end
        else begin
            o_div_clk = clk_div | clk_odd_div ; // odd divide
        end   
    end
    else begin
        o_div_clk = i_ref_clk ; 
    end
end

endmodule