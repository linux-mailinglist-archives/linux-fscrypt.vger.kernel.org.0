Return-Path: <linux-fscrypt+bounces-273-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 394C18B08C6
	for <lists+linux-fscrypt@lfdr.de>; Wed, 24 Apr 2024 13:55:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E63CF2883B0
	for <lists+linux-fscrypt@lfdr.de>; Wed, 24 Apr 2024 11:55:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33E1C15AAD6;
	Wed, 24 Apr 2024 11:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KxzELcN2"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B192A15AAB1
	for <linux-fscrypt@vger.kernel.org>; Wed, 24 Apr 2024 11:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713959740; cv=none; b=MVvNFMcmMMhQXhqhkoACh7In5QENIs0WK8n1tD/8Jk65MIBzmfIveYaQKKaffyxv9NaN5ykNU4wz+JKe0qotO7bqLEliR9a8peSr11+tWNKbBk/pzJoMHLNFkg3KoPiG+FE50ZvmRDaN946ql832AoleOh04DQMucKWGTfRxZiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713959740; c=relaxed/simple;
	bh=x0ulmsdl5RuhYqdg6GD1eT7t+LIW/ozJ7a/1sk7ZCXQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LNtCk3fDdG8F63uwv5bFu5wTXFNHGn73QxrJx+opxLTDIkMZuDMOM6y94Az89ZYYBb76qU2a5s+WaDGj1seBUe2TT/fLN19QJU+kOkOiS5CSGaQp7ovKie99EnaZywjZuBkGe32WNwHiPYHMA6pXKgnHnJ9/RBkCAgUhF/1/0wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KxzELcN2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713959737;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=shY7D2Xkj39HblvBkB6u0hIcRZjO+25LFPaiz5EXkkE=;
	b=KxzELcN2+Xt4+A/BfU8QJkc5TumJq8wtgeRYD+VuudSi3Nwb0aLBSkwcfJpODlXItCdr/a
	w0wg/tvs7VHt00R82CIrhZj4VHBK3Wvv6fVUzDTL34B7cKSJRIhFvfbho+GOBXIAlxJJBI
	TySnKeYoUtKsLS729yJ4d1VuF83oli4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-153-p_Xaf-A1PziAq2p72aIzDg-1; Wed, 24 Apr 2024 07:55:35 -0400
X-MC-Unique: p_Xaf-A1PziAq2p72aIzDg-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3477835b2f7so3937499f8f.0
        for <linux-fscrypt@vger.kernel.org>; Wed, 24 Apr 2024 04:55:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713959734; x=1714564534;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=shY7D2Xkj39HblvBkB6u0hIcRZjO+25LFPaiz5EXkkE=;
        b=W8fxosGvxbH42ETeWxYvB6z1VTn2BHaPluvsBr3PkSlUtZiUeXmTk/XKN9K6xtovPE
         WJ/7E6SJ2x4tiFO3LgcHUvTaQens1jHuGn4O/zUNunMSphiVCTRA7jh6YNm+/c7OYCfX
         5C4Uwus1MsMOAZ3EK54p93c5DOXYl45ayvuskGpc0RltiwJ0njxYWJ6uTGdgzGu6J2Am
         5YwYZXML5RzRoB2kJGLcTZQJM0FE9IH808nXy/UFucdhE5E9k2CQTxbd5NAubopzEFYj
         CiinxwNd+njweMk5MEMPmZyZx3WE3rbUZsgSaF4IbLAH9UDU3ReX/43wu/Yye4fqJfEH
         TrxQ==
X-Forwarded-Encrypted: i=1; AJvYcCW0n4Zpl1qIFkc1MDhky0XdzWnVctSaYKQxHTpdfZ4Dh/0/9iKhns0+H7OxPUneBxXyzXzxVhI+jeLF+204E6Erl5yxNtX3Eb6/INB7+Q==
X-Gm-Message-State: AOJu0YymXGNr1IcH477aVh+gIwT0201Ehx3guYeO79g5ON1R89LlNodY
	qwsYLGSGUoxGHcmw6C3dmvBUKtF52yBU23LEaC57PsK81iF5jYEr7H3WPDqqaSdbGR39X+OCUuy
	8wmALh5+dUST3iirUobQbeh+MPGaRdoAUVRO7tw+qs7TW4p4eQM2QYt564Zz3QyI=
X-Received: by 2002:adf:f404:0:b0:343:a6fc:b2e8 with SMTP id g4-20020adff404000000b00343a6fcb2e8mr1528178wro.26.1713959734280;
        Wed, 24 Apr 2024 04:55:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHra7RXL6CvmI80rpOQzWmziqfED09Pw5xpeVTp+VRYu0eXdYaseI+50tOqQTeJA45mfepL4Q==
X-Received: by 2002:adf:f404:0:b0:343:a6fc:b2e8 with SMTP id g4-20020adff404000000b00343a6fcb2e8mr1528165wro.26.1713959733807;
        Wed, 24 Apr 2024 04:55:33 -0700 (PDT)
Received: from ?IPV6:2003:cb:c70d:1f00:7a4e:8f21:98db:baef? (p200300cbc70d1f007a4e8f2198dbbaef.dip0.t-ipconnect.de. [2003:cb:c70d:1f00:7a4e:8f21:98db:baef])
        by smtp.gmail.com with ESMTPSA id t14-20020adff60e000000b0034599eca6c9sm16971570wrp.41.2024.04.24.04.55.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Apr 2024 04:55:33 -0700 (PDT)
Message-ID: <7c52ae2a-8f72-4c3c-b4b3-24b50bdb5486@redhat.com>
Date: Wed, 24 Apr 2024 13:55:32 +0200
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] mm: Remove page_mapping()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net
References: <20240423225552.4113447-1-willy@infradead.org>
 <20240423225552.4113447-7-willy@infradead.org>
Content-Language: en-US
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20240423225552.4113447-7-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 24.04.24 00:55, Matthew Wilcox (Oracle) wrote:
> All callers are now converted, delete this compatibility wrapper.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>   include/linux/pagemap.h | 1 -
>   mm/folio-compat.c       | 6 ------
>   2 files changed, 7 deletions(-)
> 
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index b6f14e9a2d98..941f7ed714b9 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -399,7 +399,6 @@ static inline void filemap_nr_thps_dec(struct address_space *mapping)
>   #endif
>   }
>   
> -struct address_space *page_mapping(struct page *);
>   struct address_space *folio_mapping(struct folio *);
>   struct address_space *swapcache_mapping(struct folio *);
>   
> diff --git a/mm/folio-compat.c b/mm/folio-compat.c
> index f31e0ce65b11..f05906006b3c 100644
> --- a/mm/folio-compat.c
> +++ b/mm/folio-compat.c
> @@ -10,12 +10,6 @@
>   #include <linux/swap.h>
>   #include "internal.h"
>   
> -struct address_space *page_mapping(struct page *page)
> -{
> -	return folio_mapping(page_folio(page));
> -}
> -EXPORT_SYMBOL(page_mapping);
> -
>   void unlock_page(struct page *page)
>   {
>   	return folio_unlock(page_folio(page));

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


