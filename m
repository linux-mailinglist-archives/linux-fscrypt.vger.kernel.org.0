Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7BF606BF0
	for <lists+linux-fscrypt@lfdr.de>; Fri, 21 Oct 2022 01:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbiJTXMf (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 20 Oct 2022 19:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiJTXMe (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 20 Oct 2022 19:12:34 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F7391C711D;
        Thu, 20 Oct 2022 16:12:33 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 330291F93A;
        Thu, 20 Oct 2022 23:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1666307552;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rUcCwsk0Z0A9XOSBaRWeTrTSWKe4NeV7gUrkFzP6Vws=;
        b=ylFTgPOhCeVXmf6YoO1psKuEG4v0Uo8ciZiHwXYzSxtdzcfLhPV58gwiPtH2X/U8lTAQeg
        czuLUgBZ5rDsleYVM7gkOGdTtYXuToJ5cRMIYQouhUS/5DAlWhS91lV1PvYugg0NU5kWvg
        kdJkf6kb+KjpTT1PwcnYY9DHuZPr66E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1666307552;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rUcCwsk0Z0A9XOSBaRWeTrTSWKe4NeV7gUrkFzP6Vws=;
        b=ehCnGHXQ8K2rZi+jfw0ZJCCWi/DWD8/o2lDL7Ceeb++10FdMeLq70SQA/F7L6oJQaRFbj1
        zjOhrz5YsFyTdrCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E093E13494;
        Thu, 20 Oct 2022 23:12:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id IxMBNt/VUWMNVQAAMHmgww
        (envelope-from <dsterba@suse.cz>); Thu, 20 Oct 2022 23:12:31 +0000
Date:   Fri, 21 Oct 2022 01:12:20 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v3 00/22] btrfs: add fscrypt integration
Message-ID: <20221020231220.GO13389@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1666281276.git.sweettea-kernel@dorminy.me>
 <Y1G/y2h3/uX95Z8E@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1G/y2h3/uX95Z8E@sol.localdomain>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Oct 20, 2022 at 02:38:19PM -0700, Eric Biggers wrote:
> On Thu, Oct 20, 2022 at 12:58:19PM -0400, Sweet Tea Dorminy wrote:
> > This is a changeset adding encryption to btrfs.
> 
> Please always say which git tree and commit your patchset applies too.  Or pass
> --base to git format-patch.  I tried upstream and btrfs, and neither worked :-(

I had the same problem but found a close commit where it applies, you
can find it at

https://github.com/kdave/btrfs-devel ext/sweettea/fscrypt-v3

There's one fixup so it compiles without warnings and so far it fails
to compile with CONFIG_FS_ENCRYPTION disabled.
