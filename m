Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38BE158095A
	for <lists+linux-fscrypt@lfdr.de>; Tue, 26 Jul 2022 04:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbiGZCQM (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 25 Jul 2022 22:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232129AbiGZCQL (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 25 Jul 2022 22:16:11 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD74CDEE2;
        Mon, 25 Jul 2022 19:16:10 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 3BC0880A59;
        Mon, 25 Jul 2022 22:16:09 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1658801770; bh=zQjumHcwx8N+P46ydn2wqo3CdRvzwnPt6y51NEbiEPM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=g6rxf5sjPgRwr6BMe+ppWZq9UFe+KB7VQPNPj8u8i3avNXB8hq+9lw42rcfsQbutf
         ijrUeL18/rx+hgImZ5GStRzy4cQUpWmErHgJyJRlvdDX+f3EVGFEVVAZ2ItkKgKAKC
         zS+KJXGOz+0EKZgLBBSDtRKco0ZFqgdwJCMTzpAbEAoqoonqXzJuOcDnGEu03dEK29
         GAkmm2rfig99lTqhUfv+K02IHiJmdvWyydwAtcx0K17g9bjy5hLDpqiDl4UPvfL/2N
         yI1Hu7/HbR5f/jYngVoel89koJ7N9ti4+IqTop6dyzTUlrgCO3Glk87+m8/uQ/gKzR
         Z+HNEJw5YV8kw==
Message-ID: <7130dd3f-202c-2e70-c37f-57be9b85548b@dorminy.me>
Date:   Mon, 25 Jul 2022 22:16:07 -0400
MIME-Version: 1.0
Subject: Re: [PATCH RFC 4/4] fscrypt: Add new encryption policy for btrfs.
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, osandov@osandov.com,
        kernel-team@fb.com
References: <cover.1658623235.git.sweettea-kernel@dorminy.me>
 <675dd03f1a4498b09925fbf93cc38b8430cb7a59.1658623235.git.sweettea-kernel@dorminy.me>
 <Yt8oEiN6AkglKfIc@sol.localdomain>
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
In-Reply-To: <Yt8oEiN6AkglKfIc@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org



On 7/25/22 19:32, Eric Biggers wrote:
> On Sat, Jul 23, 2022 at 08:52:28PM -0400, Sweet Tea Dorminy wrote:
>> Certain filesystems may want to use IVs generated and stored outside of
>> fscrypt's inode-based IV generation policies.  In particular, btrfs can
>> have multiple inodes referencing a single block of data, and moves
>> logical data blocks to different physical locations on disk; these two
>> features mean inode or physical-location-based IV generation policies
>> will not work for btrfs. For these or similar reasons, such filesystems
>> may want to implement their own IV generation and storage for data
>> blocks.
>>
>> Plumbing each such filesystem's internals into fscrypt for IV generation
>> would be ungainly and fragile. Thus, this change adds a new policy,
>> IV_FROM_FS, and a new operation function pointer, get_fs_derived_iv.  If
>> this policy is selected, the filesystem is required to provide the
>> function pointer, which populates the IV for a particular data block.
>> The IV buffer passed to get_fs_derived_iv() is pre-populated with the
>> inode contexts' nonce, in case the filesystem would like to use this
>> information; for btrfs, this is used for filename encryption.  Any
>> filesystem using this policy is expected to appropriately generate and
>> store a persistent random IV for each block of data.
> 
> This is changed from the original proposal to store just a random "starting IV"
> per extent, right? 

This is intended to be a generic interface that doesn't require any 
particular IV scheme from the filesystem. In practice, the btrfs side of 
the code is using a per-extent starting IV, as originally proposed. I 
don't see a way for the interface to require IVs per extent, but maybe 
there is a better way than this. Or, is there more detail I can add to 
the change description to clarify that the filesystem doesn't 
necessarily have to store an IV for each individual data block?

> Given that this new proposal uses per-block metadata, has
> support for authenticated encryption been considered? Has space been reserved
> in the per-block metadata for authentication tags so that authenticated
> encryption support could be added later even if it's not in the initial version?

I don't know sufficiently much about authenticated encryption to have 
considered it. As currently drafted, btrfs encrypts before checksumming 
if checksums are enabled, and checks against checksums before 
decrypting. Although at present we haven't discussed authentication 
tags, btrfs could store them in a separate itemtype which could be added 
at any time, much as we currently store fsverity data. We do have 
sufficient room saved for adding other encryption types, if necessary; 
we could use some of that to indicate the existence of authentication 
tags for the extents' data.

> 
> Also, could the new IV generation method just be defined as RANDOM_IV instead of
> IV_FROM_FS?  Why do individual filesystems have to generate the IVs?  Shouldn't
> IV generation happen in common code, with filesystems just storing and
> retrieving the IVs?
I think you're imagining an interface similar to get/set_context, where 
the first time a block is written the filesystem's set_IV method is 
called, and subsequent encryption/decryption calls get_IV, which is 
definitely elegant in its symmetry. But I'm not sure how to have a 
per-block set_IV and also only store an IV per extent, and it would be a 
significant cost to store an IV per block.

I would be happy to add a fscrypt_get_random_iv() method, instead of 
having the filesystem call get_random_bytes() itself, if you'd like.

Thank you!

Sweet Tea
