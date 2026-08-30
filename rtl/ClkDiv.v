module  ClkDiv (
    input wire i_ref_clk ,
    input wire i_rst_n ,
    input wire i_clk_en ,
    input wire [7:0] i_div_ratio ,
    output reg o_div_clk
);  
    // clk_div
    reg clk_even_div ;
    reg clk_odd_div_1 ;
    reg clk_odd_div_2 ;     

    
    // counter edges
    reg [7:0] count_positive ; 
    reg [7:0] count_negative ;       
    reg [7:0] count_even ;
    reg [7:0] count_odd_pos_1 ; 
    reg [7:0] count_odd_pos_2 ;
    reg [7:0] count_odd_neg_1 ; 
    reg [7:0] count_odd_neg_2 ;       

    // enable
    wire enable ;
    assign enable = i_clk_en && ( i_div_ratio != 0) && ( i_div_ratio != 1) ; 

    // even logic
    wire is_even ;
    assign is_even = ~ i_div_ratio[0] ;

    // counter_positive logic 
    always @(posedge i_ref_clk or negedge i_rst_n) begin
        if(!i_rst_n) begin
            count_positive <= 0 ;
        end
        else if (enable) begin
            count_positive <= count_positive + 1 ; 
        end
        else begin
            count_positive <= 0 ;
        end
    end

    // counter_positive logic 
    always @(negedge i_ref_clk or negedge i_rst_n) begin
        if(!i_rst_n) begin
            count_negative <= 0 ;
        end
        else if (enable) begin
            count_negative <= count_negative + 1 ; 
        end
        else begin
            count_negative <= 0 ;
        end
    end    
  
    // divided even clock logic 
    always @(posedge i_ref_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            clk_even_div <= 0 ;
            count_even <= 0 ;            
        end

        else if (enable && is_even) begin
            if (count_positive == count_even) begin
                clk_even_div <= ~ clk_even_div ;
                count_even <= count_even + (i_div_ratio >> 1) ;
            end 
        end  
        else begin
            clk_even_div <= 0 ;
            count_even <= 0 ; 
        end   
    end

    // divided odd clock logic 
    always @(posedge i_ref_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            clk_odd_div_1 <= 0 ;
            count_odd_pos_1 <= 0 ;
            count_odd_pos_2 <= 0 ;            
        end

        else if (enable && !(is_even)) begin
            if (count_positive == count_odd_pos_1 || count_positive == (count_odd_pos_2 + ((i_div_ratio-1) >> 1))) begin
                clk_odd_div_1 <= ~ clk_odd_div_1 ;
                if (count_positive == count_odd_pos_1) begin
                    count_odd_pos_1 <= count_odd_pos_1 + i_div_ratio ;
                end
                else begin
                    count_odd_pos_2 <= count_odd_pos_2 + i_div_ratio ;
                end
            end 
        end  
        else begin
            clk_odd_div_1 <= 0 ;
            count_odd_pos_1 <= 0 ;
            count_odd_pos_2 <= 0 ; 
        end   
    end

always @(negedge i_ref_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            clk_odd_div_2 <= 0 ;
            count_odd_neg_1 <= 0 ;
            count_odd_neg_2 <= 0 ;            
        end

        else if (enable && !(is_even)) begin
            if (count_negative == count_odd_neg_1 || count_negative == (count_odd_neg_2 + ((i_div_ratio-1) >> 1))) begin
                clk_odd_div_2 <= ~ clk_odd_div_2 ;
                if (count_negative == count_odd_neg_1) begin
                    count_odd_neg_1 <= count_odd_neg_1 + i_div_ratio ;
                end
                else begin
                    count_odd_neg_2 <= count_odd_neg_2 + i_div_ratio ;
                end
            end 
        end  
        else begin
            clk_odd_div_2 <= 0 ;
            count_odd_neg_1 <= 0 ;
            count_odd_neg_2 <= 0 ; 
        end   
    end            

always @(*) begin
    if(enable) begin
        if(is_even) begin
            o_div_clk = clk_even_div ; // even divide
        end
        else begin
            o_div_clk = clk_odd_div_1 | clk_odd_div_2 ; // odd divide
        end   
    end
    else begin
        o_div_clk = i_ref_clk ; 
    end
end

endmodule