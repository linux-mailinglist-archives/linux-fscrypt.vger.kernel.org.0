Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF9085B0D67
	for <lists+linux-fscrypt@lfdr.de>; Wed,  7 Sep 2022 21:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbiIGTng (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 7 Sep 2022 15:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiIGTnf (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 7 Sep 2022 15:43:35 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02D1BA74C5;
        Wed,  7 Sep 2022 12:43:34 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id A4F10340C4;
        Wed,  7 Sep 2022 19:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1662579812;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EP/1Vlbw0S1UBbwYHHOBOq3U6vSqqSVRO1eynQXcM9Q=;
        b=SvBHqO4oiak30Dq/lfM86S04N9lNz5H5ZVcz+XsX/WtChTmE9TDnPuGl+c2U/I3G510YR3
        Go+Z7mq9P1enXyAxZtVXOTh7gWPI4HYtPWYJ+BneGDe7kpkcM3dco1pF6iwgJoK2oRvTLQ
        xLryoAxt52B6i3fxCCONA5GDWDECQSM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1662579812;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EP/1Vlbw0S1UBbwYHHOBOq3U6vSqqSVRO1eynQXcM9Q=;
        b=Yal7LMJlsecELjsUeQ/qh3i+LOuItLuPmH/IBuY4D5o2W7Ii+s606bQJZglIiZZsCOJh+S
        Si+v5GAKHp/CB4Dg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6740713A66;
        Wed,  7 Sep 2022 19:43:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 9I1TGGT0GGOHNAAAMHmgww
        (envelope-from <dsterba@suse.cz>); Wed, 07 Sep 2022 19:43:32 +0000
Date:   Wed, 7 Sep 2022 21:38:09 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 00/20] btrfs: add fscrypt integration
Message-ID: <20220907193809.GH32411@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1662420176.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1662420176.git.sweettea-kernel@dorminy.me>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Sep 05, 2022 at 08:35:15PM -0400, Sweet Tea Dorminy wrote:
> This is a changeset adding encryption to btrfs.
> 
> Last October, Omar Sandoval sent out a design document for having fscrypt
> integration with btrfs [1]. In summary, it proposes btrfs storing its
> own encryption IVs on a per-file-extent basis. fscrypt usually encrypts
> files using an IV derived from per-inode information; this would prevent
> snapshotting or reflinking or data relocation for btrfs. We have
> refined this into a fscrypt extent context object, opaque to the
> filesystem, which fscrypt uses to generate an IV associated with each
> block in an extent. Thus, all the inodes sharing a particular
> key and file extent may decrypt the extent.
> 
> This series implements this integration for the simple
> case, non-compressed data extents. Followup changes will allow
> encryption of compressed extents, inline extents, and verity items, and
> will add tests around subvolume encryption. This series should provide
> encryption for the simplest cases, but this series should not be used in
> production, as there are likely bugs.
>  
> Preliminary btrfs-progs changes are available at [2]; fstests changes
> are available at [3].

I did a quick pass to check if there's anything that could be merged to
6.1 as preparatory, the fname is a candidate but I've also seen random
coding style issues that I'd like to get fixed first.

One thing I've noticed is that the incompat bit is only defined but not
used anywhere. Any functional change should be guarded behind it, and
once the implementation is complete the enabling part is in a separate
patch.

Regarding the build config options, I assume that the fscrypt support is
optional, so it should build with and without the option. I'm not sure
I've see enough ifdefs for that. For such features there should be a
line in btrfs_print_mod_info, like we have eg. for verity.

I'll post other comments under the patches.
