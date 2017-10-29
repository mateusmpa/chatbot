module FaqModule
  class ListService
    def initialize(params, action)
      # TODO: identify origin and set company
      @company = Company.last
      @action = action
      @query = params['query']
    end

    def call
      if @action == 'search'
        faqs = Faq.search(@query).where(company: @company)
      elsif @action == 'search_by_hashtag'
        faqs = []
        @company.faqs.each do |faq|
          faq.hashtags.each do |hashtag|
            faqs << faq if hashtag.name == @query
          end
        end
      else
        faqs = @company.faqs
      end

      response = "*Perguntas e Respostas* \n\n"
      faqs.each do |faq|
        response += "*#{faq.id}* - "
        response += "*#{faq.question}*\n"
        response += ">#{faq.answer}\n"
        faq.hashtags.each do |hashtag|
          response += "_##{hashtag.name}_ "
        end
        response += "\n\n"
      end
      (faqs.count > 0) ? response : 'Nada encontrado'
    end
  end
end
