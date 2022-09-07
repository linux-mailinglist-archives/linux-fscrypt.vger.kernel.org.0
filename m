Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D15805B0F45
	for <lists+linux-fscrypt@lfdr.de>; Wed,  7 Sep 2022 23:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbiIGVjH (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 7 Sep 2022 17:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiIGVjG (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 7 Sep 2022 17:39:06 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C68B7EFB;
        Wed,  7 Sep 2022 14:39:05 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id C62E1803EF;
        Wed,  7 Sep 2022 17:39:04 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1662586744; bh=scXC3vBL6EzVJa+BcD5DJ4xup57i/rOj2t6GeJw+1Ds=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=giR3/rD2emxfSGUIjERjhcG2fwkpjzkQ1t+Kz3kf1Gg6Z4cH/sCdvwliIE2ASIgK+
         YC1bhnqn/7S45MbA8YtY2gk2RqtgRRd6G71xlydFu88tLnn0LX1uuylzJ37XtPDHmE
         6GK2CvQBIDxQ2+rxoVvQxhDo+iBO/hA5LKVBKmUIFjAws3lwOHtWoFzDfcq+Od1Jh2
         kHtOLxILuppZyKZRvhhN1gs1fGMEM5wgsgyyy5p1risJjIJQzA1PIOSnqznu+8wPkB
         n8WdrIe0AHXWaFXiVtL0hceFYaDlnMZZBxxVJ8zA7lM5twyxY4AUGDp4xym146qHqJ
         esOfubSVMx5EA==
MIME-Version: 1.0
Date:   Wed, 07 Sep 2022 17:39:04 -0400
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     dsterba@suse.cz
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 15/20] btrfs: store a fscrypt extent context per normal
 file extent
In-Reply-To: <20220907211053.GM32411@twin.jikos.cz>
References: <cover.1662420176.git.sweettea-kernel@dorminy.me>
 <460baa45489be139b48e7b152852bda919363b4c.1662420176.git.sweettea-kernel@dorminy.me>
 <20220907211053.GM32411@twin.jikos.cz>
Message-ID: <0b06375915f5ef9529682e2d71dce6bd@dorminy.me>
X-Sender: sweettea-kernel@dorminy.me
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


> FSCRYPT_EXTENT_CONTEXT_MAX_SIZE is 33 and btrfs_fscrypt_extent_context
> is part of extent_map, that's quite common object. Random sample from 
> my
> desktop right now is around 800k objects so this is noticeable. Needs a
> second look.
> 
>> +
>>  extern const struct fscrypt_operations btrfs_fscrypt_ops;
>>  #endif /* BTRFS_FSCRYPT_H */
>> --- a/fs/btrfs/ordered-data.h
>> +++ b/fs/btrfs/ordered-data.h
>> @@ -99,6 +99,7 @@ struct btrfs_ordered_extent {
>>  	u64 disk_bytenr;
>>  	u64 disk_num_bytes;
>>  	u64 offset;
>> +	struct btrfs_fscrypt_extent_context fscrypt_context;
> 
> And another embedded btrfs_fscrypt_extent_context, that can also get a
> lot of slab objects.

I could certainly define fscrypt_extent_context's as a separate btree 
object type, and/or have them be separately allocated and just have a 
pointer in the various structures to keep track of them. I didn't have a 
separate object for them since its only a 17 or 33 byte object (at 
present) on a per-btrfs_file_extent basis, but maybe that would be 
better?

I could also #ifdef CONFIG_FS_ENCRYPTION the member in each structure, 
if that would help over and beyond either of the previous things.
