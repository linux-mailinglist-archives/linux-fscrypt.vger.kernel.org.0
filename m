Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D737A6F8D29
	for <lists+linux-fscrypt@lfdr.de>; Sat,  6 May 2023 02:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbjEFAf6 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 5 May 2023 20:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbjEFAf6 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 5 May 2023 20:35:58 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE425FF2
        for <linux-fscrypt@vger.kernel.org>; Fri,  5 May 2023 17:35:56 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 024F680266;
        Fri,  5 May 2023 20:35:54 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1683333355; bh=9OI3zVbaQUfh3jvK7rZ5bQ83DTc5JbjKuUq0YKQajeI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=qFLaTDD5ndjeJklNQh8/TT3PT1Zp2XMJ/5FC6Dj2muFyQiwepxfp6qC5KP3mSYqnM
         S0JG/g0aO4dfdeS7E4MZ+PuhBx0Vx8UpBlsJgK11TyWRCnDPHzPj2k/hItMvATetsI
         zuZ19I1E2KXT1/csPRSNsC3nXX/0cl3WbZnE8wgtJYFiJXB/OOeWsaD1FvMRteNrOF
         RWLbH0JoI7Z6qMuOSdnQI1EkYBD5Q5Tx6O7VpE1zbrGmkP/Y2Fu2Mtc1098NKJl7U4
         FWiBzUEm0iZERSa6U75xaQYAzXcN04rBMn/pxd69BFl7O4/pL/FYkKKc+JSLQGQivD
         /YLe84MxAKwKw==
Message-ID: <6f860e67-c998-0066-5f04-bc394164c5ba@dorminy.me>
Date:   Fri, 5 May 2023 20:35:53 -0400
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
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
In-Reply-To: <ZFWFzUE6r30yVPB+@gmail.com>
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



On 5/5/23 18:40, Eric Biggers wrote:
> On Fri, May 05, 2023 at 08:15:44AM -0400, Sweet Tea Dorminy wrote:
>>
>>> As I mentioned earlier
>>> (https://lore.kernel.org/r/Y7NQ1CvPyJiGRe00@sol.localdomain),
>>> blk-crypto-fallback actually already solved the problem of caching
>>> crypto_skcipher objects for I/O.  And, it's possible for a filesystem to *only*
>>> support blk-crypto, not filesystem-layer contents encryption.  You'd just need
>>> to put btrfs encryption behind a new kconfig option that is automatically
>>> selected by CONFIG_FS_ENCRYPTION_INLINE_CRYPT && CONFIG_BLK_ENCRYPTION_FALLBACK.
>>>
>>> (BTW, I'm thinking of simplifying the kconfig options by removing
>>> CONFIG_FS_ENCRYPTION_INLINE_CRYPT.  Then, the blk-crypto code in fs/crypto/ will
>>> be built if CONFIG_FS_ENCRYPTION && CONFIG_BLK_INLINE_ENCRYPTION.)
>>>
>>> Indeed, filesystem-layer contents encryption is a bit redundant these days now
>>> that blk-crypto-fallback exists.  I'm even tempted to make ext4 and f2fs support
>>> blk-crypto only someday.  That was sort of the original plan, actually...
>>>
>>> So, I'm wondering if you've considered going the blk-crypto-fallback route?
>>
>> I did, and gave it a shot, but ran into problems because as far as I can
>> tell it requires having a bio to crypt. For verity data and inline extents,
>> there's no obvious bio, and even if we tried to construct a bio pointing at
>> the relevant data, it's not necessarily sector- sized or aligned. I couldn't
>> figure out a good way to make it work, but maybe it's better to special-case
>> those or there's something I'm not seeing.
> 
> ext4 and f2fs just don't use inline data on encrypted files.  I.e. when an encrypted file is
> created, it always uses non-inline data.  Is that an option for btrfs?

It's not impossible (though it's been viewed as a fair deficiency in 
last year's changesets), but it's not the only user of data needing 
encryption stored inline instead of separately:
> 
> For the verity metadata, how are you thinking of encrypting it, exactly?  Verity metadata is
> immutable once written, so surely it avoids many of the issues you are dealing with for extents?  It
> should just need one key, and that key could be set up at file open time.  So I don't think it will
> need the key pool at all?

Yes, it should be able to use whatever the interface is for extent 
encryption, whether that uses pooled keys or something else. However, 
btrfs stores verity data in 2k chunks in the tree, similar to inline 
data, so it has the same difficulties.

(I realized after sending that we also want to encrypt xattrs, which are 
similarly stored as items in the tree instead of blocks on disk.)

We could have separate pools for inline and non-inline prepared keys (or 
not pool inline keys at all?)

Thanks!

Sweet Tea
