class Phone < ActiveRecord::Base
  def self.by_manufacturer_metric
    apple_set = Phone.where("manufacturer = 'Apple'")
    apple_short = 0
    apple_medium = 0
    apple_long = 0
    apple_set.each{|model|
      if model['salesRankShortTerm']
        apple_short += model['salesRankShortTerm']
      end
      if model['salesRankMediumTerm']
        apple_medium += model['salesRankMediumTerm']
      end
      if model['salesRankLongTerm']
        apple_long += model['salesRankLongTerm']
      end
    }
    samsung_set = Phone.where("manufacturer = 'Samsung'")
    samsung_short = 0
    samsung_medium = 0
    samsung_long = 0
    samsung_set.each{|model|
      if model['salesRankShortTerm'] != nil
        samsung_short += model['salesRankShortTerm']
      end
      if model['salesRankMediumTerm'] != nil
        samsung_medium += model['salesRankMediumTerm']
      end
      if model['salesRankLongTerm'] != nil
        samsung_long += model['salesRankLongTerm']
      end
    }
    data = [Hash['category' => 'short', 'label' => 'Today', 'Apple' => apple_short, 'Samsung' => samsung_short],
      Hash['category' => 'medium', 'label' => '2 To 4 Days Ago', 'Apple' => apple_medium, 'Samsung' => samsung_medium],
      Hash['category' => 'long', 'label' => '5 to 21 Days Ago', 'Apple' => apple_long, 'Samsung' => samsung_long]]
  end

  def self.by_carrier_metric
    apple_set = Phone.where("manufacturer = 'Apple'")
    apple_unlocked = 0
    apple_verizon = 0
    apple_att = 0
    apple_sprint = 0
    apple_set.each{|model|
      if model['classId'] and model['bestSellingRank']
        case model['classId']
          when 313
            apple_att += model['bestSellingRank']
          when 326
            apple_unlocked += model['bestSellingRank']
          when 327
            apple_verizon += model['bestSellingRank']
          when 322
            apple_sprint += model['bestSellingRank']
        end
      end
    }

    samsung_set = Phone.where("manufacturer = 'Samsung'")
    samsung_unlocked = 0
    samsung_verizon = 0
    samsung_att = 0
    samsung_sprint = 0
    samsung_set.each{|model|
      if model['classId'] and model['bestSellingRank']
        case model['classId']
          when 313
            samsung_att += model['bestSellingRank']
          when 326
            samsung_unlocked += model['bestSellingRank']
          when 327
            samsung_verizon += model['bestSellingRank']
          when 322
            samsung_sprint += model['bestSellingRank']
        end
      end
    }

    data = [Hash['category' => 'ATT', 'label' => 'AT&T', 'Apple' => apple_att, 'Samsung' => samsung_att],
      Hash['category' => 'Sprint', 'label' => 'Sprint', 'Apple' => apple_sprint, 'Samsung' => samsung_sprint],
      Hash['category' => 'Unlocked', 'label' => 'Unlocked', 'Apple' => apple_unlocked, 'Samsung' => samsung_unlocked],
      Hash['category' => 'Verizon', 'label' => 'Verizon', 'Apple' => apple_verizon, 'Samsung' => samsung_verizon]]
  end

  def self.by_price_metric
    apple_set = Phone.where("manufacturer = 'Apple'")
    apple_under_200 = 0
    apple_200_to_400 = 0
    apple_400_and_over = 0
    apple_set.each{|model|
      if model['regularPrice'] and model['bestSellingRank']
        if model['regularPrice'] < 200.0
          apple_under_200 += model['bestSellingRank']
        elsif model['regularPrice'] >= 200.0 and model['regularPrice'] < 400.0
          apple_200_to_400 += model['bestSellingRank']
        elsif model['regularPrice'] >= 400.0
          apple_400_and_over += model['bestSellingRank']
        end
      end
    }
    samsung_set = Phone.where("manufacturer = 'Samsung'")
    samsung_under_200 = 0
    samsung_200_to_400 = 0
    samsung_400_and_over = 0
    samsung_set.each{|model|
      if model['regularPrice'] and model['bestSellingRank']
        if model['regularPrice'] < 200.0
          samsung_under_200 += model['bestSellingRank']
        elsif model['regularPrice'] >= 200.0 and model['regularPrice'] < 400.0
          samsung_200_to_400 += model['bestSellingRank']
        elsif model['regularPrice'] >= 400.0
          samsung_400_and_over += model['bestSellingRank']
        end
      end
    }
    data = [Hash['category' => 'under_200', 'label' => 'Under $200', 'Apple' => apple_under_200, 'Samsung' => samsung_under_200],
      Hash['category' => '200_to_400', 'label' => '$200 To $400', 'Apple' => apple_200_to_400, 'Samsung' => samsung_200_to_400],
      Hash['category' => '400_and_over', 'label' => '$400 And Over', 'Apple' => apple_400_and_over, 'Samsung' => samsung_400_and_over]]
  end
end
