Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4690D5BC153
	for <lists+linux-fscrypt@lfdr.de>; Mon, 19 Sep 2022 04:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbiISCSR (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 18 Sep 2022 22:18:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiISCSP (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 18 Sep 2022 22:18:15 -0400
X-Greylist: delayed 600 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 18 Sep 2022 19:18:14 PDT
Received: from protestant.ebb.org (protestant.ebb.org [50.56.179.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B1C318B3E;
        Sun, 18 Sep 2022 19:18:14 -0700 (PDT)
Received: from localhost (unknown [216.161.86.18])
        (Authenticated sender: bkuhn)
        by protestant.ebb.org (Postfix) with ESMTPSA id 958BB8208F;
        Sun, 18 Sep 2022 19:00:29 -0700 (PDT)
Date:   Sun, 18 Sep 2022 19:00:17 -0700
From:   "Bradley M. Kuhn" <bkuhn@ebb.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-btrfs@vger.kernel.org, linux-spdx@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 10/20] btrfs: factor a fscrypt_name matching method
Message-ID: <YyfNMcUM+OHn5qi8@ebb.org>
References: <cover.1662420176.git.sweettea-kernel@dorminy.me>
 <685c8abce7bdb110bc306752314b4fb0e7867290.1662420176.git.sweettea-kernel@dorminy.me>
 <20220909101521.GS32411@twin.jikos.cz>
 <Yxs43SlMqqJ4Fa2h@infradead.org>
 <20220909133400.GY32411@twin.jikos.cz>
 <b4d3d155-e614-2075-8918-3082c42e099f@jilayne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b4d3d155-e614-2075-8918-3082c42e099f@jilayne.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Regarding
https://btrfs.wiki.kernel.org/index.php/Developer%27s_FAQ#Copyright_notices_in_files.2C_SPDX

On Fri, Sep 09, 2022 at 06:00:13AM -0700, Christoph Hellwig wrote:

> > > The wiki is incorrect.  The SPDX tag deals with the licensing tags
> > > only.  It is not a replacement for the copyright notice in any way, and
> > > having been involved with Copyright enforcement I can tell you that at
> > > least in some jurisdictions Copytight notices absolutely do matter.

This is a very good point.

The current Wiki page for btrfs (linked above) says:
> There's no need to put the copyright notices in individual files that are
> new, renamed or split.
…
> Note that removing the copyright from existing files is not trivial and
> would require asking the original authors or current copyright holders. The
> status will be inconsistent but at least new contributions won't continue
> adding new ones. The current licensing practices are believed to be
> sufficient.

This is admittedly a very tough problem to solve.  Nevertheless, the concern
that I have with that recommendation above is that it gives copyright holders
whose notices are grandfathered an additional notice preservation that new
copyright holders don't have equal access to.  It's particular problematic
because new contributors are unable to have contributions included unless
they remove copyright notices.

Again, I realize the trade-offs are really tough here; removing existing
copyright notices without explicit permission is a *serious* problem (both a
GPL violation and a statutory violation of copyright generally in many
jurisdictions).  OTOH, a list of every last copyright holder is painfully
unwieldy — even if you combine it into a single location.

Most importantly, I want to point out the bigger, implicit trade-off here
that some may not realize.  If you relying on Git history to have copyright
notice information, it does make the entire Git repository a required part of
the complete, corresponding source under GPLv2.  This will become even more
certain when contributors are being told that they may *not* include a
copyright notice and that their copyright information will appear in metadata
instead.  They can reasonably interpret the “appropriately publish on each
copy an appropriate copyright notice” in GPLv2§1 to mean the copyright
notices in the Git metadata.

J Lovejoy wrote:
> Can you update the wiki text to remove "SPDX" from the heading and remove
> the sentence stating, "An initiative started in 2017 [1] aims to unify
> licensing information in all files using SPDX tags, this is driven by the
> Linux Foundation."

All of that seems accurate to me.  What part is not accurate?

Splitting the information to talk about copyright and license separately
seems a good idea, but removing accurate explanations doesn't seem like a
good idea to me …

 -- bkuhn
