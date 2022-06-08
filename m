Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9355F543D06
	for <lists+linux-fscrypt@lfdr.de>; Wed,  8 Jun 2022 21:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231506AbiFHTl0 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 8 Jun 2022 15:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbiFHTl0 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 8 Jun 2022 15:41:26 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 761E31B9;
        Wed,  8 Jun 2022 12:41:25 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1033)
        id 2150E20BE665; Wed,  8 Jun 2022 12:41:25 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2150E20BE665
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1654717285;
        bh=vMz9BKB4aoPk5o77PtYU99jrHV7jAFIQAzEeGqEMDSI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D2qJspWRAnc8qk7u9W8x/dOAfywD5xKrw+O/12trzHh6XCBRY8834bGFsxXP5GlsF
         bK7LE27T/hT/lApaX5sN9fJHdaS726wEOfCLUlGfTQHfwcVH8mlpi+kW/CaLu0hVo0
         /26vjzxa5NuEMwMIsWNFkScWQEqGMQrMMWh4UyfM=
Date:   Wed, 8 Jun 2022 12:41:25 -0700
From:   Deven Bowers <deven.desai@linux.microsoft.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org,
        serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
        axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
        eparis@redhat.com, paul@paul-moore.com, linux-doc@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, linux-audit@redhat.com,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v8 00/17] Integrity Policy Enforcement LSM (IPE)
Message-ID: <20220608194125.GA32366@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1654714889-26728-1-git-send-email-deven.desai@linux.microsoft.com>
 <YqD0QjNb+wfH+Kjq@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqD0QjNb+wfH+Kjq@casper.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Jun 08, 2022 at 08:10:58PM +0100, Matthew Wilcox wrote:
> On Wed, Jun 08, 2022 at 12:01:12PM -0700, Deven Bowers wrote:
> > IPE is a Linux Security Module which takes a complimentary approach to
> 
> Hello, IPE.  You're looking exceptionally attractive today.  Have you
> been working out?

Not nearly as often as I'd like to :)

> 
> (maybe you meant "complementary"?  ;-)

Yes, thanks. Sorry for the misspelling.


