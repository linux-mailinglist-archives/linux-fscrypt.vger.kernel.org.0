Return-Path: <linux-fscrypt+bounces-915-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 511E5C31C06
	for <lists+linux-fscrypt@lfdr.de>; Tue, 04 Nov 2025 16:10:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5CC421882A69
	for <lists+linux-fscrypt@lfdr.de>; Tue,  4 Nov 2025 15:06:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78D1D1DE8AF;
	Tue,  4 Nov 2025 15:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hnLbi/Rs"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F90128816
	for <linux-fscrypt@vger.kernel.org>; Tue,  4 Nov 2025 15:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762268756; cv=none; b=BRC4/kMPjCwD0aJ8gz18En2yy8sn/5xoRNUO+7hod+EZ+524tywiGy4SGvVkxNbygX5Qh51y9nr3iLZen7pEjHfHMKsFx9hXx2mzgaDvpo/jcgxUezWjtYi6zA3Xokb+4vCZYxVXhrU/LmwKcXJicaeXXlelTEmExrcU/9Z1khI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762268756; c=relaxed/simple;
	bh=Yp6fUD952UVKQWCkV+hXAOlbW0lYlppgeblWFreQc58=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fnABb6sqbVnx/a5kOQW12v8uNdT9NwyEcdT68Sm/7PM5AKDpT6LcwaDqEmNLP3kjzH94CO9HXwmHcSxUl/AcraTfXbHvjE2/RJmKo2r84TJtQudKE4qMk/Fw57PNoqdQZTPdUQkdTyjETbEobEC0H9wVqskfQXp2yiG+NtsnXqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hnLbi/Rs; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-294fc62d7f4so53683465ad.2
        for <linux-fscrypt@vger.kernel.org>; Tue, 04 Nov 2025 07:05:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762268754; x=1762873554; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kjsZzzSV6ptDEgOqNG45MMGnROqBWBrdMHjfc2PbPmo=;
        b=hnLbi/RskHJ62tG5fmddzuJQ/uUw2ykV9H6PKkLxB3zk/3YDH1Lqh7YLHLEkJNrQNq
         863EdxFMPtKI12/auV2fwyH+VoOfVXWij7zML30P6EuPh6MKhl1AONZBxUj6RPMIvwWG
         iQY6ltYvgiC8Wiu2KP8Lav6z9ic6xHemBuJ5qsRKw+i/wy7HB4F4emkGg2y9xRNTagfv
         GvpFfwYOYoRMVeop2I9At03yO8RqJjC4uLdPGZBYYolHuXx/2kNObyBDvW1w+8oDRW9n
         0ckCEPY9JuNKZqIS4PrSAKjjgiDi/WqTq0i6Tx8w7G+s4wKIhojHlcMGKDAAiW4ZKYdk
         Ak3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762268754; x=1762873554;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kjsZzzSV6ptDEgOqNG45MMGnROqBWBrdMHjfc2PbPmo=;
        b=Hfm+W1JFSv03CaDHfdxTLmaepeIHT8PcOXrlxXH6Gv0ZCgeD7gUk2GDhv8VV8rHUWE
         UEzO5d+sz4XPuqLSCz9hB2j+KiHnDgoLPwW4xWb648fkYl2muy7mq35mbRCJGHgd3qZR
         q0H7VApFNHbLsLeQWMPoZg/XD7PMNQMvA9b5YryvDETnsFzpozUgJNurx1oosEP2fIse
         ig3oR77XNhFdHSInN3+dMsZty+uLYwjKB+XA5ZwxWBrWX4aOXMjnD6jBtyxaeXYhiUHl
         rifvSgaY2kVycDB1SydH4mxYlGxSXZ6DkmQGvF95P/9toTjBJKaM6/rEtT07x1ADkMuh
         nNrw==
X-Forwarded-Encrypted: i=1; AJvYcCV7ewFaPgHDYgQ1msm8wCGsYMgVwFgjI7d1f9M2W8WYgXfapdDgU4CnrOd2M12x8G0HHBgl7okBFzX/70sJ@vger.kernel.org
X-Gm-Message-State: AOJu0YzPTpYXRYFtYFP0TDqdboPA5dh4jR5/PkmLqzR6lTKSiZQogd4I
	OuhFUGGRJMVPy6Yyz7LiYwehzC1NCIV6OidnXBvIYenYDWa3y1Rr6/8QNc13fcIa
X-Gm-Gg: ASbGnct3BMEGuSl9BsXMaqlzYpEKIHVixwTCFUelDg9bCgq5Eat8NpXD4z2JyN84H2o
	0WZzE+HbSDrVJBrT7NvAsqX5oqDC7GF6T755kR5UeybBYJycf3fwQHXNBrDenI+bSHy3U52Aey7
	XzLNczN4A7UXmuc7dqJL8V6WGgzwevJiEGD74bCp2KYUzK/IFeUfbXFmyRcZL1MjAg78EYiFkSY
	XaUnoLrJlWUtfFkF9C+X4QFfa6sG0MiWa6WXN9d1I+dZx2Veo8DJ8F4y0T9P3EJAp0yXVk5HMgy
	AXtDY8fwR4hfLtGiF9mUxLob7T+LEYtzwUUxvVYk7SGb/QMxZYlNydMkAZRTy6HjXRyghOvf1aa
	NxjKsV8AaKO+PV8bqf5BHMr/zJGbmf+ocwV9/wcCbc1sac0R8ruyQZyUAjdN8DNKdvTJZHdnOde
	2mD2arJVjshCIu77qoFpEN41+Ua/NdmzDje1BHywZJ/Vaprd6A4Qvw7U5eyqHqOUoyMuMYJg==
X-Google-Smtp-Source: AGHT+IF6GMlcuTvJ/QMvT7CMF97mhy83YwPs7iC6oKLK4oKXG45cls7H4Vrjj+0VVpTVu8RpWQY3oA==
X-Received: by 2002:a17:902:d48e:b0:295:986f:6514 with SMTP id d9443c01a7336-295986f65fdmr98727215ad.9.1762268754106;
        Tue, 04 Nov 2025 07:05:54 -0800 (PST)
Received: from ?IPV6:2409:8a00:79b4:1a90:a428:f9f:5def:1227? ([2409:8a00:79b4:1a90:a428:f9f:5def:1227])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-296019982c7sm29883325ad.25.2025.11.04.07.05.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Nov 2025 07:05:53 -0800 (PST)
Message-ID: <b8f06e62-27dc-462e-83ad-33b179daf8a2@gmail.com>
Date: Tue, 4 Nov 2025 23:05:49 +0800
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] fscrypt: fix left shift underflow when
 inode->i_blkbits > PAGE_SHIFT
To: Christoph Hellwig <hch@infradead.org>, Eric Biggers <ebiggers@kernel.org>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>, Theodore Ts'o <tytso@mit.edu>,
 linux-fscrypt@vger.kernel.org, Yongpeng Yang <yangyongpeng@xiaomi.com>,
 linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
 Luis Chamberlain <mcgrof@kernel.org>
References: <20251030072956.454679-1-yangyongpeng.storage@gmail.com>
 <20251103164829.GC1735@sol> <aQnftXAg93-4FbaO@infradead.org>
Content-Language: en-US
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
In-Reply-To: <aQnftXAg93-4FbaO@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/2025 7:12 PM, Christoph Hellwig wrote:
> On Mon, Nov 03, 2025 at 08:48:29AM -0800, Eric Biggers wrote:
>>>   	*inode_ret = inode;
>>> -	*lblk_num_ret = ((u64)folio->index << (PAGE_SHIFT - inode->i_blkbits)) +
>>> +	*lblk_num_ret = (((u64)folio->index << PAGE_SHIFT) >> inode->i_blkbits) +
> 
> This should be using folio_pos() instead of open coding the arithmetics.
> 

How about this modification: using "<< PAGE_SHIFT" instead of "* 
PAGE_SIZE" for page_offset and folio_pos?

--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -333,7 +333,7 @@ static bool bh_get_inode_and_lblk_num(const struct 
buffer_head *bh,
         inode = mapping->host;

         *inode_ret = inode;
-       *lblk_num_ret = ((u64)folio->index << (PAGE_SHIFT - 
inode->i_blkbits)) +
+       *lblk_num_ret = ((u64)folio_pos(folio) >> inode->i_blkbits) +
                         (bh_offset(bh) >> inode->i_blkbits);
         return true;
  }
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 09b581c1d878..72eeb1841bc3 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1026,7 +1026,7 @@ static inline pgoff_t page_pgoff(const struct 
folio *folio,
   */
  static inline loff_t folio_pos(const struct folio *folio)
  {
-       return ((loff_t)folio->index) * PAGE_SIZE;
+       return ((loff_t)folio->index) << PAGE_SHIFT;
  }

  /*
@@ -1036,7 +1036,7 @@ static inline loff_t page_offset(struct page *page)
  {
         struct folio *folio = page_folio(page);

-       return folio_pos(folio) + folio_page_idx(folio, page) * PAGE_SIZE;
+       return folio_pos(folio) + (folio_page_idx(folio, page) << 
PAGE_SHIFT);
  }

Yongpeng,

