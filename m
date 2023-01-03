Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A60D65B862
	for <lists+linux-fscrypt@lfdr.de>; Tue,  3 Jan 2023 01:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbjACAdU (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 2 Jan 2023 19:33:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjACAdT (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 2 Jan 2023 19:33:19 -0500
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89740F76;
        Mon,  2 Jan 2023 16:33:17 -0800 (PST)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id D7F7C82554;
        Mon,  2 Jan 2023 19:33:16 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1672705997; bh=2Ape2jvMCzZ7NKwT6eDyn94Rvn4XohpK+z1OwuN/YPs=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=DqP2BYNIdGW4PI4VyRy2w4iLjSe4eliTtVVxNljJ5BypHfEFX3Zi5uuYjOCj7TuTo
         Kz1i52XPSw5qBAJ7oVOPv9IWqXUkOgYsaeTGAYArfQfVYvVNmX7879FztbkFr6n5RF
         JrvC2kBfI38nVdkk9Tsy5QVFIfCBeX6ZZw2soxgdazcWDoZTQE/tTMRgEKX3yaDFji
         ZKE/zUhEywk6soUdFTwjqWKzVj1+vedtTEg34dTq5GYWevukGAvnKkpoTK13s9PW7e
         AhhaoM4iJLYVIeZa2M7Oi3MkHzShK4kIX8K47dPKjvxe02VKNaSKBQgQ7H9rFCdI8b
         V2rD/QgdvsLnQ==
Message-ID: <66385ee9-3e11-f5a6-259d-ae504ab6dfaa@dorminy.me>
Date:   Mon, 2 Jan 2023 19:33:15 -0500
MIME-Version: 1.0
Subject: Re: [RFC PATCH 15/17] fscrypt: allow load/save of extent contexts
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, paulcrowley@google.com,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
References: <cover.1672547582.git.sweettea-kernel@dorminy.me>
 <fd5c7a78de125737abe447370fe37f9fe90155d6.1672547582.git.sweettea-kernel@dorminy.me>
 <Y7NQ1CvPyJiGRe00@sol.localdomain>
 <686e2eb9-b218-6b23-472c-b6035bd2186b@dorminy.me>
 <Y7NgCKPnVybgBaq/@sol.localdomain>
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
In-Reply-To: <Y7NgCKPnVybgBaq/@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


> 
> Anyway, crypto_alloc_skcipher() takes a lock (crypto_alg_sem) under which memory
> is allocated with GFP_KERNEL.  So neither preloading kernel modules nor
> memalloc_nofs_save() helps for it; it's still not GFP_NOFS-safe.

I'm still confused. My understanding is that memalloc_nofs_save() means 
all allocations on that thread until memalloc_nofs_restore() is called 
effectively gets GFP_NOFS appended to the allocation flags. So since 
crypto_alloc_skcipher()'s allocation appears to be on the same thread as 
we'd be calling memalloc_nofs_save/restore(), it would presumably get 
allocated as though it had flags GFP_KERNEL | GFP_NOFS, even though the 
call is kzalloc(..., GFP_KERNEL, ...).

I don't understand how the lock would make a difference. Can you elaborate?

Sorry for my confusion...

Sweet Tea
