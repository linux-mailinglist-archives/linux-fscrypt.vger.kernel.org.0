Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B65C5B528D
	for <lists+linux-fscrypt@lfdr.de>; Mon, 12 Sep 2022 03:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbiILBml (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 11 Sep 2022 21:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiILBmk (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 11 Sep 2022 21:42:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B24125287;
        Sun, 11 Sep 2022 18:42:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F26C361155;
        Mon, 12 Sep 2022 01:42:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E75BFC433D6;
        Mon, 12 Sep 2022 01:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662946958;
        bh=ZgTqZ7XvQxtdH0yNcnlKYw8R931nUj5j036mmb5KPBs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gGdZeTnkRuLSnjd2k81S33Ioy8BSe1ZdphLt58CXsnR605I+KL+Ss5vrOPfgt7Yik
         w6+lnNSP5xXjdgJDmT/kWXIrOKBCfxl42b0pfldbi3UfrO5jAnewqF4Z1fCblsbTb0
         SmCRGR4AbwF35ymX2yz1KdGjFSQ1kf2OQceK+hKz8ED2HYXRTmPyO8cBjYL6Mnjk8j
         U71xZczeq/Nq5sxj/Ch+/Pcrq0Yp6WGZg8WVI6sUqwlosH06AKvQGh8zyUdBC9kk9G
         SH3vBeUtvOqoxCek7KvYGflJ2V/SjSmA3Dl43Yk99ciDCxcMST9P1pFhb6+KnVehx7
         kMpx7tgs0L0pg==
Date:   Sun, 11 Sep 2022 20:42:31 -0500
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH v2 02/20] fscrypt: add flag allowing partially-encrypted
 directories
Message-ID: <Yx6Oh67pW+Fs6E0P@quark>
References: <cover.1662420176.git.sweettea-kernel@dorminy.me>
 <5e762e300535cbb9f04b25a97e1d13fd082f5b0e.1662420176.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e762e300535cbb9f04b25a97e1d13fd082f5b0e.1662420176.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Sep 05, 2022 at 08:35:17PM -0400, Sweet Tea Dorminy wrote:
> From: Omar Sandoval <osandov@osandov.com>
> 
> Creating several new subvolumes out of snapshots of another subvolume,
> each for a different VM's storage, is a important usecase for btrfs.  We
> would like to give each VM a unique encryption key to use for new writes
> to its subvolume, so that secure deletion of the VM's data is as simple
> as securely deleting the key; to avoid needing multiple keys in each VM,
> we envision the initial subvolume being unencrypted. However, this means
> that the snapshot's directories would have a mix of encrypted and
> unencrypted files. During lookup with a key, both unencrypted and
> encrypted forms of the desired name must be queried.
> 
> To allow this, add another FS_CFLG to allow filesystems to opt into
> partially encrypted directories.
> 
> Signed-off-by: Omar Sandoval <osandov@osandov.com>
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>  fs/crypto/fname.c       | 17 ++++++++++++++++-
>  include/linux/fscrypt.h |  2 ++
>  2 files changed, 18 insertions(+), 1 deletion(-)

I'm still trying to wrap my head around what this part involves exactly.  This
is a pretty big change in semantics.

Could this be moved to the end of the patchset, or is this a fundamental part of
the btrfs fscrypt support that the rest of your patchset depends on?  I'd think
it would be a lot easier to review if this change was an add-on at the end.

One thing to keep in mind is that FS_IOC_SET_ENCRYPTION_POLICY failing on
nonempty directories can actually be very useful, since it makes it possible to
detect bugs where people create files in encrypted directories (expecting that
they are encrypted) before an encryption policy actually gets assigned.  Since
FS_IOC_SET_ENCRYPTION_POLICY fails in that case, such bugs can be detected and
fixed.

If it succeeds, then everything would just silently work and some files wouldn't
be encrypted as intended.  That's kind of scary.

It might be warranted to use an encryption policy flag to explicitly indicate
that mixing encrypted and unencrypted files is being allowed.

- Eric
