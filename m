Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD8D705611
	for <lists+linux-fscrypt@lfdr.de>; Tue, 16 May 2023 20:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbjEPSfF (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 16 May 2023 14:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231819AbjEPSe5 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 16 May 2023 14:34:57 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F3FB61AD
        for <linux-fscrypt@vger.kernel.org>; Tue, 16 May 2023 11:34:53 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 9D29C81433;
        Tue, 16 May 2023 14:34:52 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1684262093; bh=SpPTLLIM60IzIeO9tOu+LTBG9Pzi7CzCKxUmlesHtf0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=wKdHIcIfjVzsc0M/JQ0sm3Xrsyjh4a5QfPLD3LfyPZKnAJ0O+KwGYHFUrRRZiI6TO
         PP6qbXHykRP2McvK8i/QtXG6ybDX6lljyhn3/MRmzEZf4MAcRgnZUevp1shmMA2viy
         qXU1ZXisWMB000Vxge3VoH0VG5QXHkjvrHO1A71TxIpeGZRmBeqPbctiVJjCcqwKgG
         s5okVsyOpB7RfEYdh2QEUfq3o3NRtor/DYNevLkrXNBzD9IMSg5m/M04mjQZI143x/
         qenfnnWDuVUMu5GGMa2y5II7hQnuULNveNjp8vsXyzwig041WeX3BCY89nMWdEFFiU
         ckiubSgXY/Wdg==
Message-ID: <80496cfe-161d-fb0d-8230-93818b966b1b@dorminy.me>
Date:   Tue, 16 May 2023 14:34:51 -0400
MIME-Version: 1.0
Subject: Re: [PATCH v1 0/7] fscrypt: add pooled prepared keys facility
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, kernel-team@meta.com
References: <cover.1681871298.git.sweettea-kernel@dorminy.me>
 <20230502034736.GA1131@sol.localdomain>
 <e7ee1491-e67c-6461-8825-6f39bf723c86@dorminy.me>
 <ZFWFzUE6r30yVPB+@gmail.com>
 <6f860e67-c998-0066-5f04-bc394164c5ba@dorminy.me>
 <20230515064047.GC15871@sol.localdomain>
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
In-Reply-To: <20230515064047.GC15871@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


> To clarify my suggestion, blk-crypto could be used for file contents
> en/decryption at the same time that filesystem-layer crypto is used for verity
> metadata en/decryption.  blk-crypto and filesystem-layer crypto don't need to be
> mutually exclusive, even on the same file.

That's a great point. I'm dropping these two patchsets and updating the 
original one at the start of the year to use blk-crypto, as per our 
discussions both here and at LSF.

> 
> Also, I'm glad that you're interested in xattr encryption, but unfortunately
> it's a tough problem, and all the other filesystems that implement fscrypt have
> left it out.  You have enough other things to worry about, so I think leaving
> xattr encryption out for now is the right call.  Similarly, the other
> filesystems that implement fscrypt have left out encryption of inline data,
> instead opting to disable inline data on encrypted files.

A good point. I'll defer xattrs and inline data (and verity) for the 
first round, and add in doing those with inode infos after getting 
extent infos working well.

> 
> Anyway, the main reason I'm sending this email is actually that I wanted to
> mention another possible solution to the per-extent key problem that I just
> became aware of.  In v6.4-rc1, the crypto API added a new function
> crypto_clone_tfm() which allocates a new tfm object, given an existing one.
> Unlike crypto_alloc_tfm(), crypto_clone_tfm() doesn't take any locks.  See:
> https://lore.kernel.org/linux-crypto/ZDefxOq6Ax0JeTRH@gondor.apana.org.au/T/#u
> 
> For now, only shash and ahash tfms can be cloned.  However, it looks like
> support for cloning skcipher tfms could be added.
> 
> With "cloning" skcipher tfms, there could just be a crypto_skcipher per extent,
> allocated on the I/O path.  That would solve the problem we've been trying to
> solve, without having to bring in the complexity of "pooled prepared keys".

Huh. A cool new thing for sure. I suppose one would have an initial tfm 
per supported crypto alg, and clone it for each extent as needed. That's 
definitely better than pooling prepared keys. I'll explore this after 
everything else, and work on blk-crypto oriented for now.

Thanks!

Sweet Tea
