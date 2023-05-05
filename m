Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0BE46F82C0
	for <lists+linux-fscrypt@lfdr.de>; Fri,  5 May 2023 14:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231853AbjEEMPu (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 5 May 2023 08:15:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231256AbjEEMPu (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 5 May 2023 08:15:50 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCFB01A112
        for <linux-fscrypt@vger.kernel.org>; Fri,  5 May 2023 05:15:48 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 735DB80265;
        Fri,  5 May 2023 08:15:46 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1683288947; bh=vvoKsfLN19ip1kMmoKmBxoZaBxBp3IP0qYlU1tn27OM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=oNuNebVt6NNB461XNHdIvqBnic+DSHsoToMnFlCtgxy6iuSbxs0gxGRb1muiRzBTa
         6YtJA5KPPr+XqteIE/xW90jw9y5rgGRhuFuoNFGTOjoA5LuZzCL0aUVnRU8am/ybHe
         4piwEzohmuu6MlhtA3Mz1jDbgnMVJN8MPH8XLU0/Fry0lpdKiynBXdHtX2HUE39xyl
         8JcLphEGhgiSAekjAbCeLSAteQsTggtotw46BjcXwOxsPzYh2CC3V8XJXjAZUT6op7
         13/1cZ2NROoO+dtweVsd9yHA4RRbp0s+42Zb3/94S+YD1knY7DJ5vo3wzvCNBO2KKZ
         ouNgc8Up3FsIA==
Message-ID: <e7ee1491-e67c-6461-8825-6f39bf723c86@dorminy.me>
Date:   Fri, 5 May 2023 08:15:44 -0400
MIME-Version: 1.0
Subject: Re: [PATCH v1 0/7] fscrypt: add pooled prepared keys facility
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, kernel-team@meta.com
References: <cover.1681871298.git.sweettea-kernel@dorminy.me>
 <20230502034736.GA1131@sol.localdomain>
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
In-Reply-To: <20230502034736.GA1131@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


> As I mentioned earlier
> (https://lore.kernel.org/r/Y7NQ1CvPyJiGRe00@sol.localdomain),
> blk-crypto-fallback actually already solved the problem of caching
> crypto_skcipher objects for I/O.  And, it's possible for a filesystem to *only*
> support blk-crypto, not filesystem-layer contents encryption.  You'd just need
> to put btrfs encryption behind a new kconfig option that is automatically
> selected by CONFIG_FS_ENCRYPTION_INLINE_CRYPT && CONFIG_BLK_ENCRYPTION_FALLBACK.
> 
> (BTW, I'm thinking of simplifying the kconfig options by removing
> CONFIG_FS_ENCRYPTION_INLINE_CRYPT.  Then, the blk-crypto code in fs/crypto/ will
> be built if CONFIG_FS_ENCRYPTION && CONFIG_BLK_INLINE_ENCRYPTION.)
> 
> Indeed, filesystem-layer contents encryption is a bit redundant these days now
> that blk-crypto-fallback exists.  I'm even tempted to make ext4 and f2fs support
> blk-crypto only someday.  That was sort of the original plan, actually...
> 
> So, I'm wondering if you've considered going the blk-crypto-fallback route?

I did, and gave it a shot, but ran into problems because as far as I can 
tell it requires having a bio to crypt. For verity data and inline 
extents, there's no obvious bio, and even if we tried to construct a bio 
pointing at the relevant data, it's not necessarily sector- sized or 
aligned. I couldn't figure out a good way to make it work, but maybe 
it's better to special-case those or there's something I'm not seeing.


