Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 992992BB469
	for <lists+linux-fscrypt@lfdr.de>; Fri, 20 Nov 2020 20:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730855AbgKTSxL (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 20 Nov 2020 13:53:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729154AbgKTSxL (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 20 Nov 2020 13:53:11 -0500
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8C1FC0617A7
        for <linux-fscrypt@vger.kernel.org>; Fri, 20 Nov 2020 10:53:10 -0800 (PST)
Received: by mail-il1-x142.google.com with SMTP id z14so7698964ilm.10
        for <linux-fscrypt@vger.kernel.org>; Fri, 20 Nov 2020 10:53:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KGmpqHXl2E5s58RjENuxxIDXzRsrZkrBKU0UphW/tR8=;
        b=TqIGKvJKPK0LUXhmilcXhOka1tg1kLUiKi7ISSNktbKjbiSOicJEmiktUi4xgS5AtU
         r4lUrkGPrs2z3TiS++cbxgGVVEbsMvv/VcpQUW4h/j0skRqbCqZOXp94MTnRUUrMQy8k
         h/ojIxYkFV7aT7omVFBOgZj88t7rtja7EjX1OQdkgV97PgSbQCxW+Ek19iAnxyK1ARgU
         TlAZtWadfNPWmQVIcHPo3gKGqh2XqjVTueMhzeQNJqBoFyddCCjAVS4dcprd8IBrS/5e
         K+pKJSnypocwmHXxMZAnmklUw3a9kISwnFnpyKOuiUDQCkBJ1zzxvGsyge+OUA8D/9U9
         Nurw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KGmpqHXl2E5s58RjENuxxIDXzRsrZkrBKU0UphW/tR8=;
        b=Rk1ZA7m+3gDJ7PQRWOvFWHgPP6atGDHxqnVc0Ehe279Kl4DRW64w3OBWyRIEY1LqXE
         sn5wyBBRV1AvUmYQI49QZwo+te0N+DiuU5096ZoLsWCa59x0CeHEP7Wrm/eO3R+EASr9
         ie/blAp8aEeUbuf0xh13WhS5AndClpJJzi9vzO3c/7KOZ23coisK1wtdJM5Wir5Sh34l
         V1AkMdbvxJcf+A+UvpnNsPbv/HqFG+GtpBRgZPivXCGTVgrc6slQtQTXGDIrvibusJu1
         7aUGgb7Ak5VLxgFO7IH9xaMML7/ChLUWNtVda0eTyPXslkQ/KNxUhZwEDbERd/t+TuHz
         NPCg==
X-Gm-Message-State: AOAM531vLqwGYxKl4ZozFUc3d4ad9JpFmTi0uX65/+6smnsGDLPpVzxb
        MPbxrnas9dcqMGB+l5oEC2Jm+Y39m7yhUg==
X-Google-Smtp-Source: ABdhPJzq+otmd5dEMF2vstKk7rtHVtNtjfOIqW98HYZS9XU3pcHjmdZBIcCVxu3T75f3CJnw7ARc8g==
X-Received: by 2002:a92:cf51:: with SMTP id c17mr28414694ilr.113.1605898389924;
        Fri, 20 Nov 2020 10:53:09 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id c13sm2177021ilr.39.2020.11.20.10.53.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2020 10:53:09 -0800 (PST)
Subject: Re: [PATCH v2] block/keyslot-manager: prevent crash when num_slots=1
To:     Eric Biggers <ebiggers@kernel.org>, linux-block@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, Satya Tangirala <satyat@google.com>
References: <20201111214855.428044-1-ebiggers@kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d0d64133-1d4f-fa50-18c1-8f3d09bb2a70@kernel.dk>
Date:   Fri, 20 Nov 2020 11:53:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201111214855.428044-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 11/11/20 2:48 PM, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> If there is only one keyslot, then blk_ksm_init() computes
> slot_hashtable_size=1 and log_slot_ht_size=0.  This causes
> blk_ksm_find_keyslot() to crash later because it uses
> hash_ptr(key, log_slot_ht_size) to find the hash bucket containing the
> key, and hash_ptr() doesn't support the bits == 0 case.
> 
> Fix this by making the hash table always have at least 2 buckets.
> 
> Tested by running:
> 
>     kvm-xfstests -c ext4 -g encrypt -m inlinecrypt \
>                  -o blk-crypto-fallback.num_keyslots=1

Applied for 5.10, thanks.

-- 
Jens Axboe

