Return-Path: <linux-fscrypt+bounces-269-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BA21B8B08B4
	for <lists+linux-fscrypt@lfdr.de>; Wed, 24 Apr 2024 13:54:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD5BA1C23063
	for <lists+linux-fscrypt@lfdr.de>; Wed, 24 Apr 2024 11:54:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABADA15ADAE;
	Wed, 24 Apr 2024 11:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QJWyIyrz"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B6515A4B4
	for <linux-fscrypt@vger.kernel.org>; Wed, 24 Apr 2024 11:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713959641; cv=none; b=U4AktxcAUt1Qt9E2xBv2hhxEyQN/d/fU7jZBk/ZguHedT/frH6JN9Kbco/FaFU8snlNGvqbHfErgEgz08kiGQdJEFG07vNtRWYuxKpREVLUGCe0RNHBUugRwxTdUl3GkyMvLSvNy/p1KoKxmts8uogzyfNm3baCsPkYIWrEkQxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713959641; c=relaxed/simple;
	bh=ww2JxpYpF0XczFNR1GhFbsboFXQLx7UkQ+RpKAoq1J8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O1nUZggVtrkm34BDEeJpOXQ7eqbl17Jd9Yt9hgTSz04uUOF8KZqwf4VVeQK4BIW0AyxcX/KjX6kZ12+Rlc1P29PiEBgk4/axhYzFGjOJrYh5YYJhsiKbgX0pKpF+FEdzXsl4OD5za98ZFENIwRAa5QxbfjeYnLmj2NHH9rDfjIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QJWyIyrz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713959639;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=TH8YUqHOGuGz5crtgTdIkgIlrRRSZkH07Batsj5ogKk=;
	b=QJWyIyrzqWS/BmjCV/UUhW5AAQyFX0TKSJo7Cx3UedRI7Ng67bHuvMF3TAGLhPSPdXrbYI
	OTD23wM41gLX5UaDRfwjr68YHe56m2lhmz9c4oMo61aa3pK/KKnRLI5bbbj05jqP3uG/PO
	qYkHFmKa833u0IsxzQhFqR3gYyH6/6U=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-584-ibBASqBUPLy6G4mAIJjtOw-1; Wed, 24 Apr 2024 07:53:57 -0400
X-MC-Unique: ibBASqBUPLy6G4mAIJjtOw-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-41ab62f535aso9886955e9.0
        for <linux-fscrypt@vger.kernel.org>; Wed, 24 Apr 2024 04:53:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713959636; x=1714564436;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TH8YUqHOGuGz5crtgTdIkgIlrRRSZkH07Batsj5ogKk=;
        b=NCUqV3G3oZ9rKbmUW9/RXSad9zq+BtzjQ+pr1QyFFm5e4iPDK58gSdKl6EotQWtWvu
         fMpQKd+kfgFk+kP7z1P17D8JDpivXGSYEX39gv7UIZQv0hzKQFXuKPltf6+yU9WX5AIB
         bMTPufc9+4aJLun4C0FIQCjZxDuaYxozjqg7P594a5p7Nc9T2ahF0A1wTXnP1pAHwVRQ
         M+coflAuK9inR2kaSqpk5jMF3SgP0n+LJ4AFcCAp5S/AFpTMa+eKrgFEdbnq+YhlX5tf
         Ca6v/2SJflFt7G4p4uMNrU0lXnWqkQhY0Q5vn9L3aubajzN7LWry/XKuhjbKx1bv89Th
         sgcQ==
X-Forwarded-Encrypted: i=1; AJvYcCX2FFNXr7OTNHGITT5BSVo4tBaIFK77ZKi3DIJEbPvh4GZrye3jHONICfdt7NKYphV/uGP69EIWgZZwaLHJriP99a8cUH/nvQcL0B3Qxw==
X-Gm-Message-State: AOJu0YyB5G5KhscbBIJGE/eR9TX5j7zMKfo+ManZ5pnbBJC98ouHAIAK
	rWJkkYomigbiQeZdW/O7AOjCddtQ1AcQWWwxU2ThcJekXzAJl80NY7iO1X3pplZm9c1cCNF6kfC
	pNRnLCAZakbgE4D9yYVnj584A3tfVu8dcSQqrjttWXqD/WpSBfQwzNHIos6KXbtM=
X-Received: by 2002:a05:600c:5355:b0:41a:8374:7eae with SMTP id hi21-20020a05600c535500b0041a83747eaemr1847967wmb.31.1713959636215;
        Wed, 24 Apr 2024 04:53:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFbU86FkcTk3PDpnSMe0ssLkgpwlPFEMBWvCFZ7quhTVEpXacQP8GDaqQGTOgrxZJ6/7drxMw==
X-Received: by 2002:a05:600c:5355:b0:41a:8374:7eae with SMTP id hi21-20020a05600c535500b0041a83747eaemr1847955wmb.31.1713959635892;
        Wed, 24 Apr 2024 04:53:55 -0700 (PDT)
Received: from ?IPV6:2003:cb:c70d:1f00:7a4e:8f21:98db:baef? (p200300cbc70d1f007a4e8f2198dbbaef.dip0.t-ipconnect.de. [2003:cb:c70d:1f00:7a4e:8f21:98db:baef])
        by smtp.gmail.com with ESMTPSA id z9-20020a05600c0a0900b00418916f5848sm23175969wmp.43.2024.04.24.04.53.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Apr 2024 04:53:55 -0700 (PDT)
Message-ID: <d844c8e1-bb8b-4cdd-87c7-c8b6b3fbef74@redhat.com>
Date: Wed, 24 Apr 2024 13:53:54 +0200
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] f2fs: Convert f2fs_clear_page_cache_dirty_tag to use
 a folio
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net
References: <20240423225552.4113447-1-willy@infradead.org>
 <20240423225552.4113447-3-willy@infradead.org>
Content-Language: en-US
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20240423225552.4113447-3-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 24.04.24 00:55, Matthew Wilcox (Oracle) wrote:
> Removes uses of page_mapping() and page_index().
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>   fs/f2fs/data.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> index 5d641fac02ba..9f74c867d790 100644
> --- a/fs/f2fs/data.c
> +++ b/fs/f2fs/data.c
> @@ -4100,11 +4100,12 @@ const struct address_space_operations f2fs_dblock_aops = {
>   
>   void f2fs_clear_page_cache_dirty_tag(struct page *page)
>   {
> -	struct address_space *mapping = page_mapping(page);
> +	struct folio *folio = page_folio(page);
> +	struct address_space *mapping = folio->mapping;
>   	unsigned long flags;
>   
>   	xa_lock_irqsave(&mapping->i_pages, flags);
> -	__xa_clear_mark(&mapping->i_pages, page_index(page),
> +	__xa_clear_mark(&mapping->i_pages, folio->index,
>   						PAGECACHE_TAG_DIRTY);
>   	xa_unlock_irqrestore(&mapping->i_pages, flags);
>   }

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


