Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2B55B386F
	for <lists+linux-fscrypt@lfdr.de>; Fri,  9 Sep 2022 15:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbiIINAa (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 9 Sep 2022 09:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiIINA2 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 9 Sep 2022 09:00:28 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 039E671BC4;
        Fri,  9 Sep 2022 06:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=86y5u3egiuwhwOpqr54rVCTQLM24tVvojlrH7los6mQ=; b=NfAsRc24FOnWkstmpT7uyv5Ff7
        2QG2p9QbpU5pljMjgTCRKbQXO88chaw8a5gZQJt0+FeQX6+qfB0eVnN7cXZXBZQH/Bu2+OgUQpyMg
        uULi014s3ZycXM2jGzLO+13ThTYF4MTD8zjQEOeGLJ4myGHdTS+TeAcBnRwxP9Ud7m7F7ArG0bKXy
        8icnFYadfecIG9DWC4jLCff1ZmhkXcKYPvOzrB+Q21gs81XzH8YVgHgQ+O2iDzN+lgkXDZUg/RXb0
        hARGTyZj05UbO7Zu/3g1IQpFeQkhSm9wpGTBbHLTgk6hXcDSplHAHRmBjgApAB1Nz7OhqMSPqLTWp
        x2slEQbg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oWdcD-00GCOm-8l; Fri, 09 Sep 2022 13:00:13 +0000
Date:   Fri, 9 Sep 2022 06:00:13 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     David Sterba <dsterba@suse.cz>
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Omar Sandoval <osandov@osandov.com>, linux-spdx@vger.kernel.org
Subject: Re: [PATCH v2 10/20] btrfs: factor a fscrypt_name matching method
Message-ID: <Yxs43SlMqqJ4Fa2h@infradead.org>
References: <cover.1662420176.git.sweettea-kernel@dorminy.me>
 <685c8abce7bdb110bc306752314b4fb0e7867290.1662420176.git.sweettea-kernel@dorminy.me>
 <20220909101521.GS32411@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220909101521.GS32411@twin.jikos.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Sep 09, 2022 at 12:15:21PM +0200, David Sterba wrote:
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (C) 2020 Facebook
> > + */
> 
> Please use only SPDX in new files
> 
> https://btrfs.wiki.kernel.org/index.php/Developer%27s_FAQ#Copyright_notices_in_files.2C_SPDX

The wiki is incorrect.  The SPDX tag deals with the licensing tags
only.  It is not a replacement for the copyright notice in any way, and
having been involved with Copyright enforcement I can tell you that
at least in some jurisdictions Copytight notices absolutely do matter.
