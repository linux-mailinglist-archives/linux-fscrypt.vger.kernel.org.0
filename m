Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4358E1B4C51
	for <lists+linux-fscrypt@lfdr.de>; Wed, 22 Apr 2020 19:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbgDVR5t (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 22 Apr 2020 13:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726082AbgDVR5t (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 22 Apr 2020 13:57:49 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED2BFC03C1A9
        for <linux-fscrypt@vger.kernel.org>; Wed, 22 Apr 2020 10:57:47 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id k12so2437879qtm.4
        for <linux-fscrypt@vger.kernel.org>; Wed, 22 Apr 2020 10:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+pYoarVe2eYolPGvEcb/ivpn4Eh7PgXOagTP5MdBu40=;
        b=g5ghFr3y3N49tn0KlILku/aQqBp99nBYHU3GBCK04OgtCeOHi/cNIcGGwSrhq1Xzc1
         lYPPgPCMWnwZpn7qpImCGBgwmSxTKT0eP0/eNISkZBJhYGfMEQo/ifcTW6yF8zxYo1l8
         a9BfZrsSZt4kSYl+B9ITKFe5NknIcPCWE7cgv5uaaPRHuln7QGX8Q9rz5eoAYUK7uOaq
         CLBAuvrHfINf7zXLqsdVzu+3JZfLUFP5Bdmwp8n2jdOAVyjcXLHUGXOvYGzEbxm3rEsx
         hT0UjnN44rcmXwrGjVheQXca2EjV7Kp5z4NoCtd02KMNq3gbbBuqFH04EJ6sduaPDKVb
         iDcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+pYoarVe2eYolPGvEcb/ivpn4Eh7PgXOagTP5MdBu40=;
        b=X5PyKLLUmD7Wj7JRmht8yF61Sn7uNKJiBVBUkny5UeERTlYs1YJ3oIi6L7KZfjd4nx
         gS0ovy6Sd6jx+sqASA490GSWfOegzVGxuwGuIauJMJ94TfPpn12xumL3/J66uciPn8Bo
         zGinEBAlidItH3/cMzD370C43xPGXKbirPEpx/qC4ROebIpNiP8YtlRODZ2KZCffQUwv
         78o/VUfZPtjCrnLRFDrcz9VmNfTAoOb5P6zvUle4RMDj4swhv2Zu1Voy16Sq/rWzKmLA
         faj9iTuHahJE1/eCV2Hi1yiSKY/fmcFNIR2Y3aV5kkstDVOqYzjZiCyz6Nja6UOr9FN3
         iYRw==
X-Gm-Message-State: AGi0PuasWVd4iCw25op7A2u9eYQXq78KQle68QAAfO8IeugdLWUU2Jtm
        M+lNHhrgXlpX+GJLDUj5ESc=
X-Google-Smtp-Source: APiQypLl8qJ0AuSFoupQFZKuWuhPxrzNnvDs43i/jhLnDTsr2HbXWOGZfvCYEn2uirY4+pZnEh+fWA==
X-Received: by 2002:ac8:7c96:: with SMTP id y22mr27358593qtv.17.1587578267030;
        Wed, 22 Apr 2020 10:57:47 -0700 (PDT)
Received: from ?IPv6:2620:10d:c0a8:11d1::10c4? ([2620:10d:c091:480::62b])
        by smtp.gmail.com with ESMTPSA id q15sm4284928qkn.100.2020.04.22.10.57.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2020 10:57:45 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [PATCH 4/9] Move hash algorithm code to shared library
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, kernel-team@fb.com,
        Jes Sorensen <jsorensen@fb.com>
References: <20200312214758.343212-1-Jes.Sorensen@gmail.com>
 <20200312214758.343212-5-Jes.Sorensen@gmail.com>
 <20200322053802.GH111151@sol.localdomain>
Message-ID: <8b2dd7d7-4442-16e7-e251-8254551fa81b@gmail.com>
Date:   Wed, 22 Apr 2020 13:57:44 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200322053802.GH111151@sol.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 3/22/20 1:38 AM, Eric Biggers wrote:
> On Thu, Mar 12, 2020 at 05:47:53PM -0400, Jes Sorensen wrote:
>> diff --git a/libfsverity.h b/libfsverity.h
>> +struct fsverity_hash_alg {
>> +	const char *name;
>> +	unsigned int digest_size;
>> +	unsigned int block_size;
>> +	uint16_t hash_num;
>> +	struct hash_ctx *(*create_ctx)(const struct fsverity_hash_alg *alg);
>> +};
>> +
> 
> It's still a bit weird to have struct fsverity_hash_alg as part of the library
> API, since the .create_ctx() member is for internal library use only.  We at
> least need to clearly comment this:
> 
> 	struct fsverity_hash_alg {
> 		const char *name;
> 		unsigned int digest_size;
> 		unsigned int block_size;
> 		uint16_t hash_num;
> 
> 		/* for library-internal use only */
> 		struct hash_ctx *(*create_ctx)(const struct fsverity_hash_alg *alg);
> 	};
> 
> But ideally there would be nothing library-internal in the API at all.

So I looked this over again, and came up with a solution which gets rid
of struct fsverity_hash_alg from the public API. To get around it I
extended the API like this:

<uint16_t> = libfsverity_find_alg_by_name(<char *name>)
<int>      = libfsverity_digest_size(<uint16_t alg_nr>)

In order to be able to print the algorithm name and list supported
algorithms, I introduced:

<char *>   = libfsverity_alg_name(<uint16_t alg_nr>)

Cheers,
Jes
