function phase_diff = phase_difference(ch1_phase, ch2_phase)
    if ch1_phase > 0 && ch2_phase > 0
        if abs(ch1_phase-ch2_phase) < 180
            phase_diff = ch1_phase - ch2_phase;
        else
            if ch1_phase > ch2_phase
                phase_diff = 360 - (ch1_phase - ch2_phase);
            else
                phase_diff = -(360 - (ch2_phase - ch1_phase)); 
            end    
        end
    end
    
    if ch1_phase > 0 && ch2_phase < 0
        if abs(ch1_phase-ch2_phase) < 180
            phase_diff = ch1_phase - ch2_phase;
        else
            phase_diff = -(360 - (ch1_phase - ch2_phase));  
        end
    end

    if ch1_phase < 0 && ch2_phase > 0
        if abs(ch2_phase-ch1_phase) < 180
            phase_diff = ch1_phase - ch2_phase;
        else
            phase_diff = (360 - (ch2_phase - ch1_phase));  
        end
    end

    if ch1_phase < 0 && ch2_phase < 0
        if abs(ch2_phase - ch1_phase) < 180
            phase_diff = ch1_phase - ch2_phase;
        else
            if ch1_phase < ch2_phase
                phase_diff = 360 + (ch2_phase - ch1_phase);
            else
                phase_diff = -(360 + (ch1_phase - ch2_phase)); 
            end    
        end
    end    
end