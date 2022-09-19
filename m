Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 951F05BD3A4
	for <lists+linux-fscrypt@lfdr.de>; Mon, 19 Sep 2022 19:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiISR1C (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 19 Sep 2022 13:27:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbiISR0i (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 19 Sep 2022 13:26:38 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DEE827B17;
        Mon, 19 Sep 2022 10:26:12 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 2B31A22000;
        Mon, 19 Sep 2022 17:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1663608371;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HyN3pBdWU66xwbM1RFpvC+TkMPMNtg824HESp9OO4cQ=;
        b=kEOB7tSDtTAnriBQnQzeMdg3we+h7R8iWFpANbIsouFfyS3hPvjG044zGHsGnhzGYNBav2
        tlB4qofOxi2UUtPwd4PIu6K1/khfN0miPiKUhP9HyqW7ZpjcuAvno8/j6nKoCbzJt5oj0M
        AP3Ye2YssNRGLMDKP6iknRS3SN3SdiM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1663608371;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HyN3pBdWU66xwbM1RFpvC+TkMPMNtg824HESp9OO4cQ=;
        b=KY7JNrrAX08LbF1yadgV0NMqoEIWp2tiAE1mjUxgMyB6C9KhwHbyjx+FokJ5m+d14FLUql
        2tfpPQ7Mrv7kRfAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F09CF13A96;
        Mon, 19 Sep 2022 17:26:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id nIzJOTKmKGM5KQAAMHmgww
        (envelope-from <dsterba@suse.cz>); Mon, 19 Sep 2022 17:26:10 +0000
Date:   Mon, 19 Sep 2022 19:20:40 +0200
From:   David Sterba <dsterba@suse.cz>
To:     "Bradley M. Kuhn" <bkuhn@ebb.org>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-btrfs@vger.kernel.org,
        linux-spdx@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH v2 10/20] btrfs: factor a fscrypt_name matching method
Message-ID: <20220919172040.GS32411@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1662420176.git.sweettea-kernel@dorminy.me>
 <685c8abce7bdb110bc306752314b4fb0e7867290.1662420176.git.sweettea-kernel@dorminy.me>
 <20220909101521.GS32411@twin.jikos.cz>
 <Yxs43SlMqqJ4Fa2h@infradead.org>
 <20220909133400.GY32411@twin.jikos.cz>
 <b4d3d155-e614-2075-8918-3082c42e099f@jilayne.com>
 <YyfNMcUM+OHn5qi8@ebb.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YyfNMcUM+OHn5qi8@ebb.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sun, Sep 18, 2022 at 07:00:17PM -0700, Bradley M. Kuhn wrote:
> Regarding
> https://btrfs.wiki.kernel.org/index.php/Developer%27s_FAQ#Copyright_notices_in_files.2C_SPDX
> 
> On Fri, Sep 09, 2022 at 06:00:13AM -0700, Christoph Hellwig wrote:
> 
> > > > The wiki is incorrect.  The SPDX tag deals with the licensing tags
> > > > only.  It is not a replacement for the copyright notice in any way, and
> > > > having been involved with Copyright enforcement I can tell you that at
> > > > least in some jurisdictions Copytight notices absolutely do matter.
> 
> This is a very good point.

I've expanded the page hopefully correcting the confusion. It has 3
sections, about spdx, about copyright and the community perspective.

> The current Wiki page for btrfs (linked above) says:
> > There's no need to put the copyright notices in individual files that are
> > new, renamed or split.
> …
> > Note that removing the copyright from existing files is not trivial and
> > would require asking the original authors or current copyright holders. The
> > status will be inconsistent but at least new contributions won't continue
> > adding new ones. The current licensing practices are believed to be
> > sufficient.
> 
> This is admittedly a very tough problem to solve.  Nevertheless, the concern
> that I have with that recommendation above is that it gives copyright holders
> whose notices are grandfathered an additional notice preservation that new
> copyright holders don't have equal access to.  It's particular problematic
> because new contributors are unable to have contributions included unless
> they remove copyright notices.
>
> Again, I realize the trade-offs are really tough here; removing existing
> copyright notices without explicit permission is a *serious* problem (both a
> GPL violation and a statutory violation of copyright generally in many
> jurisdictions).  OTOH, a list of every last copyright holder is painfully
> unwieldy — even if you combine it into a single location.
> 
> Most importantly, I want to point out the bigger, implicit trade-off here
> that some may not realize.  If you relying on Git history to have copyright
> notice information, it does make the entire Git repository a required part of
> the complete, corresponding source under GPLv2.  This will become even more
> certain when contributors are being told that they may *not* include a
> copyright notice and that their copyright information will appear in metadata
> instead.  They can reasonably interpret the “appropriately publish on each
> copy an appropriate copyright notice” in GPLv2§1 to mean the copyright
> notices in the Git metadata.

Thanks for the reply.  Oh well, so we basically don't have good options.
