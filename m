Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7E185BD2BC
	for <lists+linux-fscrypt@lfdr.de>; Mon, 19 Sep 2022 18:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbiISQ6E (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 19 Sep 2022 12:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbiISQ6B (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 19 Sep 2022 12:58:01 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3998630F40;
        Mon, 19 Sep 2022 09:58:00 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E79CF1F898;
        Mon, 19 Sep 2022 16:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1663606678;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SOxJ3U0Rb7W102f4DXYl7Xco3lz/zmDgoQqG+oRBgH8=;
        b=0NcJ2+oWDLocgjsZXNGTm4TASttJ9P8sIqUeZtdvn+gxeGZ/eyW17zpsOsY6orvXV3vTV2
        mhVTDJVxMsjQJLL0AnRLLnddki9s/kCDqZYIhp3PP/WMUQvlrKeT1KYPVgfIKl+puAZxN0
        E0+kV8jHrYeBEVL2DwCSurrP7PkczyQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1663606678;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SOxJ3U0Rb7W102f4DXYl7Xco3lz/zmDgoQqG+oRBgH8=;
        b=0rJzhyOlRPyZByvXvs2TC7wDaPX8+3YByhZIyqroKosUo7HFut1HTk8hbnhHrHzAmB6ZC+
        TZAuAjhjnwyPbQAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 788F913A96;
        Mon, 19 Sep 2022 16:57:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ciLlG5afKGPhHQAAMHmgww
        (envelope-from <dsterba@suse.cz>); Mon, 19 Sep 2022 16:57:58 +0000
Date:   Mon, 19 Sep 2022 18:52:28 +0200
From:   David Sterba <dsterba@suse.cz>
To:     J Lovejoy <opensource@jilayne.com>
Cc:     dsterba@suse.cz, Christoph Hellwig <hch@infradead.org>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Omar Sandoval <osandov@osandov.com>, linux-spdx@vger.kernel.org
Subject: Re: [PATCH v2 10/20] btrfs: factor a fscrypt_name matching method
Message-ID: <20220919165228.GR32411@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1662420176.git.sweettea-kernel@dorminy.me>
 <685c8abce7bdb110bc306752314b4fb0e7867290.1662420176.git.sweettea-kernel@dorminy.me>
 <20220909101521.GS32411@twin.jikos.cz>
 <Yxs43SlMqqJ4Fa2h@infradead.org>
 <20220909133400.GY32411@twin.jikos.cz>
 <b4d3d155-e614-2075-8918-3082c42e099f@jilayne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b4d3d155-e614-2075-8918-3082c42e099f@jilayne.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Sep 16, 2022 at 04:18:47PM -0600, J Lovejoy wrote:
> 
> 
> On 9/9/22 7:34 AM, David Sterba wrote:
> > On Fri, Sep 09, 2022 at 06:00:13AM -0700, Christoph Hellwig wrote:
> >> On Fri, Sep 09, 2022 at 12:15:21PM +0200, David Sterba wrote:
> >>>> +// SPDX-License-Identifier: GPL-2.0
> >>>> +/*
> >>>> + * Copyright (C) 2020 Facebook
> >>>> + */
> >>> Please use only SPDX in new files
> >>>
> >>> https://btrfs.wiki.kernel.org/index.php/Developer%27s_FAQ#Copyright_notices_in_files.2C_SPDX
> >> The wiki is incorrect.  The SPDX tag deals with the licensing tags
> >> only.  It is not a replacement for the copyright notice in any way, and
> >> having been involved with Copyright enforcement I can tell you that
> >> at least in some jurisdictions Copytight notices absolutely do matter.
> > I believe you and can update the wiki text so it's more explicit about
> > the license an copyright.
> 
> Can you update the wiki text to remove "SPDX" from the heading and 
> remove the sentence stating, "An initiative started in 2017 [1] aims to 
> unify licensing information in all files using SPDX tags, this is driven 
> by the Linux Foundation."

I can consider that if you tell me why I should do that, but I don't
find anything wrong with the sentence (and I wrote it originally). It's
merely stating that something happened and points to a well known linux
kernel related web site with more details about it.
