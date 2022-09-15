Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78D2A5BA111
	for <lists+linux-fscrypt@lfdr.de>; Thu, 15 Sep 2022 20:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiIOS6S (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 15 Sep 2022 14:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiIOS6S (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 15 Sep 2022 14:58:18 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C7BB88DC4;
        Thu, 15 Sep 2022 11:58:16 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id A3CBD815F8;
        Thu, 15 Sep 2022 14:58:15 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1663268295; bh=jxil2TSpiZjUeINH3d6Nb2E6mFkEyMpwiV+LHN23cyc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cE4608iLK99tTUHYsNslz43/ejJ6tLFcwmGVW8dMpNUS+nliCCfP1BHWOiGOYugbz
         yb3sCSG/fvKyQFtYloFrfKDhO43R4kbTfjne0wNE7y0mrMXPi7lp53nDDvXvlOJkW6
         fNjGhDkju2QT4V67vQ7eObEaQ4gf0g9rT9yRuaEBDqs41ve/EVNvVQeGq258uTTrKf
         Cfw3ukTpTVbt9joztQ/ViMP1tizy+uSsdwNcBlxr5/7/mk0euZDmAyYOg1Hse2BpyP
         c3Q4pcR8RsmdxGio2a200zZmh/eXBcrydXlB85qo3v8D0KN1voJvUo+OpxaheNLYHK
         M//u24F3NIWHg==
MIME-Version: 1.0
Date:   Thu, 15 Sep 2022 14:58:15 -0400
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH v2 02/20] fscrypt: add flag allowing partially-encrypted
 directories
In-Reply-To: <Yx6Oh67pW+Fs6E0P@quark>
References: <cover.1662420176.git.sweettea-kernel@dorminy.me>
 <5e762e300535cbb9f04b25a97e1d13fd082f5b0e.1662420176.git.sweettea-kernel@dorminy.me>
 <Yx6Oh67pW+Fs6E0P@quark>
Message-ID: <d7351139e8ffe727685f5f53110a5e73@dorminy.me>
X-Sender: sweettea-kernel@dorminy.me
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


> I'm still trying to wrap my head around what this part involves 
> exactly.  This
> is a pretty big change in semantics.
> 
> Could this be moved to the end of the patchset, or is this a 
> fundamental part of
> the btrfs fscrypt support that the rest of your patchset depends on?  
> I'd think
> it would be a lot easier to review if this change was an add-on at the 
> end.

Definitely.

> 
> One thing to keep in mind is that FS_IOC_SET_ENCRYPTION_POLICY failing 
> on
> nonempty directories can actually be very useful, since it makes it 
> possible to
> detect bugs where people create files in encrypted directories 
> (expecting that
> they are encrypted) before an encryption policy actually gets assigned. 
>  Since
> FS_IOC_SET_ENCRYPTION_POLICY fails in that case, such bugs can be 
> detected and
> fixed.

I agree that this has risks of inadvertent misuse in that fashion.

The usecase I'm oriented towards is: someone builds an unencrypted 
subvolume with a container base filesystem, takes several snapshots of 
the subvolume, starts a container on each subvolume, and has each 
container encrypt its designated subvolume going forward with a 
different key. This usecase needs some way to mark a subvolume/directory 
already containing files as encrypted going forward; I've had a hard 
time coming up with a way to both protect users against such accidental 
misuse, but also allow this container usecase.

> 
> It might be warranted to use an encryption policy flag to explicitly 
> indicate
> that mixing encrypted and unencrypted files is being allowed.

Could it be sufficient to check either empty or read-only, something 
like (is_empty_dir(inode) || (FS_CFLG_PARTIAL && !inode_permission(..., 
inode, MAY_WRITE)))? Then the user is unable to accidentally write 
unencrypted data, since they've taken an action to make the directory 
read-only, until they've set a policy and key and turned the directory 
read-write again.

Thanks!
