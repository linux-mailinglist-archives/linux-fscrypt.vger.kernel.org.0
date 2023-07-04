Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47786746702
	for <lists+linux-fscrypt@lfdr.de>; Tue,  4 Jul 2023 03:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbjGDB5h (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 3 Jul 2023 21:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbjGDB5h (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 3 Jul 2023 21:57:37 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C8F3E54;
        Mon,  3 Jul 2023 18:57:35 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 439BE80B01;
        Mon,  3 Jul 2023 21:57:30 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1688435854; bh=gfc0gqjVqKnbzuewZum//66B1a6vCYnfv21vwsUbmMU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=W6tWXa462GXkPOuoP5++BWm9XN6pUlv/sKCmS5Gs4S48jJiLyYzWQtWi74rQAPjCT
         4O8Zt3HNDDcejOivrdsdmHW38I1pwdAafRui1TIJNC8h3AwFovpsChBQzP9tm3yKxe
         s1V+7Z+wD50l5eYoPoRTSLOGsOClDnsmkknM/vo/nvP6PCapQixe4hWXN3DFbSO6kg
         csUrofmm34wHVlH26Fzi2ow0TJF2p6v0EWwqDhOcKSO+eEnCH69j3o+w240bHbJ89Y
         Xgu6oITBHOt1uJicu6gmGDvm91N/V0TURA9uGaJk+PVBKr+QmTIdZ0ihMK9KQ6nwVA
         oFrVRUyNQ3AqQ==
Message-ID: <9c589884-d033-f277-58bf-735ba9120f14@dorminy.me>
Date:   Mon, 3 Jul 2023 21:57:25 -0400
MIME-Version: 1.0
Subject: Re: [PATCH v1 00/12] fscrypt: add extent encryption
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org
References: <cover.1687988246.git.sweettea-kernel@dorminy.me>
 <20230703045417.GA3057@sol.localdomain>
 <712d5490-8f36-f41d-4488-91e86e694cad@dorminy.me>
 <20230703181745.GA1194@sol.localdomain>
 <6a7d0d4a-9c79-e47d-7968-e508c266407d@dorminy.me>
 <20230704002854.GA860@sol.localdomain>
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
In-Reply-To: <20230704002854.GA860@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_SBL_CSS,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


>>> I do recall some discussion of making it possible to set an encryption policy on
>>> an *unencrypted* directory, causing new files in that directory to be encrypted.
>>> However, I don't recall any discussion of making it possible to add another
>>> encryption policy to an *already-encrypted* directory.  I think this is the
>>> first time this has been brought up.
>>
>> I think I referenced it in the updated design (fifth paragraph of "Extent
>> encryption" https://docs.google.com/document/d/1janjxewlewtVPqctkWOjSa7OhCgB8Gdx7iDaCDQQNZA/edit?usp=sharing)
>> but I didn't talk about it enough -- 'rekeying' is a substitute for adding a
>> policy to a directory full of unencrypted data. Ya'll's points about the
>> badness of having mixed unencrypted and encrypted data in a single dir were
>> compelling. (As I recall it, the issue with having mixed enc/unenc data is
>> that a bug or attacker could point an encrypted file autostarted in a
>> container, say /container/my-service, at a unencrypted extent under their
>> control, say /bin/bash, and thereby acquire a backdoor.)
>>>
>>> I think that allowing directories to have multiple encryption policies would
>>> bring in a lot of complexity.  How would it be configured, and what would the
>>> semantics for accessing it be?  Where would the encryption policies be stored?
>>> What if you have added some of the keys but not all of them?  What if some of
>>> the keys get removed but not all of them?
>> I'd planned to use add_enckey to add all the necessary keys, set_encpolicy
>> on an encrypted directory under the proper conditions (flags interpreted by
>> ioctl? check if filesystem has hook?) recursively calls a
>> filesystem-provided hook on each inode within to change the fscrypt_context.
> 
> That sounds quite complex.  Recursive directory operations aren't really
> something the kernel does.  It would also require updating every inode, causing
> COW of every inode.  Isn't that something you'd really like to avoid, to make
> starting a new container as fast and lightweight as possible?

A fair point. Can move the penalty to open or write time instead though: 
btrfs could store a generation number with the new context on only the 
directory changed, then leaf inodes or new extent can traverse up the 
directory tree and grab context from the highest-generation-number 
directory in its path to inherit from. Or btrfs could disallow changing 
except on the base of a subvolume, and just go directly to the top of 
the subvolume to grab the appropriate context. Neither of those require 
recursion outside btrfs.

>> On various machines, we currently have a btrfs filesystem containing various
>> volumes/snapshots containing starting states for containers. The snapshots
>> are generated by common snapshot images built centrally. The machines, as
>> the scheduler requests, start and stop containers on those volumes.
>>
>> We want to be able to start a container on a snapshot/volume such that every
>> write to the relevant snapshot/volume is using a per-container key, but we
>> don't care about reads of the starting snapshot image being encrypted since
>> the starting snapshot image is widely shared. When the container is stopped,
>> no future different container (or human or host program) knows its key. This
>> limits the data which could be lost to a malicious service/human on the host
>> to only the volumes containing currently running containers.
>>
>> Some other folks envision having a base image encrypted with some per-vendor
>> key. Then the machine is rekeyed with a per-machine key in perhaps the TPM
>> to use for updates and logfiles. When a user is created, a snapshot of a
>> base homedir forms the base of their user subvolume/directory, which is then
>> rekeyed with a per-user key. When the user logs in, systemd-homedir or the
>> like could load their per-user key for their user subvolume/directory.
>>
>> Since we don't care about encrypting the common image, we initially
>> envisioned unencrypted snapshot images where we then turn on encryption and
>> have mixed unenc/enc data. The other usecase, though, really needs key
>> change so that everything's encrypted. And the argument that mixed unenc/enc
>> data is not safe was compelling.
>>
>> Hope that helps?
> 
> Maybe a dumb question: why aren't you just using overlayfs?  It's already
> possible to use overlayfs with an fscrypt-encrypted upperdir and workdir.  When
> creating a new container you can create a new directory and assign it an fscrypt
> policy (with a per-container or per-user key or whatever that container wants),
> and create two subdirectories 'upperdir' and 'workdir' in it.  Then just mount
> an overlayfs with that upperdir and workdir, and lowerdir referring to the
> starting rootfs.  Then use that overlayfs as the rootfs as the container.
> 
> Wouldn't that solve your use case exactly?  Is there a reason you really want to
> create the container directly from a btrfs snapshot instead?

Hardly; a quite intriguing idea. Let me think about this with folks when 
we get back to work on Wednesday. Not sure how it goes with the other 
usecase, the base image/per-machine/per-user combo, but will think about it.
