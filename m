Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A74869F69E
	for <lists+linux-fscrypt@lfdr.de>; Wed, 22 Feb 2023 15:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbjBVOcB (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 22 Feb 2023 09:32:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbjBVOcA (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 22 Feb 2023 09:32:00 -0500
X-Greylist: delayed 600 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 22 Feb 2023 06:31:58 PST
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40163CC23;
        Wed, 22 Feb 2023 06:31:58 -0800 (PST)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id EF9E5804D6;
        Wed, 22 Feb 2023 09:13:48 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1677075229; bh=il9rnv4276jF65Zn/Xxp/phMAoBKfffNvczA2bUVS9I=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=vCHo5sqj7zZTNh0gE61RzVKZtJd/gKqH//O3MIjaVJVgQt1anRx9URN+LBPT0krJK
         WVwJ7yGBklt2deMYYhYcI59jDHXyefnpe10h8JTZok/jZb/9/baQ2XJB8ssUVhN1Jz
         nzjE0HIX0JziMnIYZE3+PGMW4Bf4uatI5nri/sMDzOfjWaTmMmv6+8OXTJjNdkbgnr
         rd6hH7jkonjW2kSbpa56ABzw2T2AbKz8OtWwpymupETTcF90fearVfFhUAJBRYP6M9
         BTZg47S93iJ17iBCb4kxLlGtQFLB7UJVMYOZBZzPQSKpW3SpCPTJTDDt6s6I0Dx07R
         vDgCB91+5zNig==
Message-ID: <6f17b268-6f6a-93dc-e6e0-ac0d982a72e0@dorminy.me>
Date:   Wed, 22 Feb 2023 09:13:47 -0500
MIME-Version: 1.0
Subject: Re: [RFC PATCH 00/17] fscrypt: add per-extent encryption keys
Content-Language: en-US
To:     Neal Gompa <ngompa13@gmail.com>
Cc:     linux-fscrypt@vger.kernel.org, ebiggers@kernel.org,
        paulcrowley@google.com, linux-btrfs@vger.kernel.org,
        kernel-team@meta.com
References: <cover.1672547582.git.sweettea-kernel@dorminy.me>
 <CAEg-Je-tcpu0u2TekzjrtQ4x0PQtV_1A300WxAiTVswjKbJjYw@mail.gmail.com>
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
In-Reply-To: <CAEg-Je-tcpu0u2TekzjrtQ4x0PQtV_1A300WxAiTVswjKbJjYw@mail.gmail.com>
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



On 2/22/23 06:52, Neal Gompa wrote:
> On Sun, Jan 1, 2023 at 12:08 AM Sweet Tea Dorminy
> <sweettea-kernel@dorminy.me> wrote:
>>
>> Last month, after a discussion of using fscrypt in btrfs, several
>> potential areas for expansion of fscrypt functionality were identified:
>> specifically, per-extent keys, authenticated encryption, and 'rekeying'
>> a directory tree [1]. These additions will permit btrfs to have better
>> cryptographic characteristics than previous attempts at expanding btrfs
>> to use fscrypt.
>>
>> This attempts to implement the first of these, per-extent keys (in
>> analogy to the current per-inode keys) in fscrypt. For a filesystem
>> using per-extent keys, the idea is that each regular file inode is
>> linked to its parent directory's fscrypt_info, while each extent in
>> the filesystem -- opaque to fscrypt -- stores a fscrypt_info providing
>> the key for the data in that extent. For non-regular files, the inode
>> has its own fscrypt_info as in current ("inode-based") fscrypt.
>>
>> IV generation methods using logical block numbers use the logical block
>> number within the extent, and for IV generation methods using inode
>> numbers, such filesystems may optionally implement a method providing an
>> equivalent on a per-extent basis.
>>
>> Known limitations: change 12 ("fscrypt: notify per-extent infos if
>> master key vanishes") does not sufficiently argue that there cannot be a
>> race between freeing a master key and using it for some pending extent IO.
>> Change 16 ("fscrypt: disable inline encryption for extent-based
>> encryption") merely disables inline encryption, when it should implement
>> generating appropriate inline encryption info for extent infos.
>>
>> This has not been thoroughly tested against a btrfs implementation of
>> the interfaces -- I've thrown out everything here and tried something
>> new several times, and while I think this interface is a decent one, I
>> would like to get input on it in parallel with finishing the btrfs side
>> of this part, and the other elements of the design mentioned in [1]
>>
>> [1] https://docs.google.com/document/d/1janjxewlewtVPqctkWOjSa7OhCgB8Gdx7iDaCDQQNZA/edit?usp=sharing
>>
>> *** BLURB HERE ***
>>
>> Sweet Tea Dorminy (17):
>>    fscrypt: factor accessing inode->i_crypt_info
>>    fscrypt: separate getting info for a specific block
>>    fscrypt: adjust effective lblks based on extents
>>    fscrypt: factor out fscrypt_set_inode_info()
>>    fscrypt: use parent dir's info for extent-based encryption.
>>    fscrypt: add a super_block pointer to fscrypt_info
>>    fscrypt: update comments about inodes to include extents
>>    fscrypt: rename mk->mk_decrypted_inodes*
>>    fscrypt: make fscrypt_setup_encryption_info generic for extents
>>    fscrypt: let fscrypt_infos be owned by an extent
>>    fscrypt: update all the *per_file_* function names
>>    fscrypt: notify per-extent infos if master key vanishes
>>    fscrypt: use an optional ino equivalent for per-extent infos
>>    fscrypt: add creation/usage/freeing of per-extent infos
>>    fscrypt: allow load/save of extent contexts
>>    fscrypt: disable inline encryption for extent-based encryption
>>    fscrypt: update documentation to mention per-extent keys.
>>
>>   Documentation/filesystems/fscrypt.rst |  38 +++-
>>   fs/crypto/crypto.c                    |  17 +-
>>   fs/crypto/fname.c                     |   9 +-
>>   fs/crypto/fscrypt_private.h           | 174 +++++++++++++----
>>   fs/crypto/hooks.c                     |   2 +-
>>   fs/crypto/inline_crypt.c              |  42 ++--
>>   fs/crypto/keyring.c                   |  67 ++++---
>>   fs/crypto/keysetup.c                  | 263 ++++++++++++++++++++------
>>   fs/crypto/keysetup_v1.c               |  24 +--
>>   fs/crypto/policy.c                    |  28 ++-
>>   include/linux/fscrypt.h               |  76 ++++++++
>>   11 files changed, 580 insertions(+), 160 deletions(-)
>>
>>
>> base-commit: b7af0635c87ff78d6bd523298ab7471f9ffd3ce5
>> --
>> 2.38.1
>>
> 
> I'm surprised that this submission generated no discussion across a
> timeframe of over a month. Is this normal for RFC patch sets?

Eric pointed out some issues with patches 1 and 15 on 1/2. I've been on 
parental leave and have been busier with new little one than expected, 
and haven't sent out a new version yet. But I'm back to work in a week 
and this is my primary priority.
