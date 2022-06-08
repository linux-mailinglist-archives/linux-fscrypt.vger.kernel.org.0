Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B751C543C87
	for <lists+linux-fscrypt@lfdr.de>; Wed,  8 Jun 2022 21:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234686AbiFHTLX (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 8 Jun 2022 15:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234573AbiFHTLW (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 8 Jun 2022 15:11:22 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C527A220DF;
        Wed,  8 Jun 2022 12:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=tSrfX4aaJXde5l4IKGahGFWY72nscoUjDqvjLBBDf1A=; b=QAKfuIECPCAIteGXFj6p/10k2E
        4GMVlqZIpYTE5XHMkaWFUjRL1gQ0tJsW2x8Ihw3LI65sb4ipePFJCB91Z62EpK7wRi3btv2DUVLGH
        /QaGabmo3Mg/DixuxUEbE0xMvBhW6f18TNpNGdrRtBq2gyEHg+d7XisZKaifYZBYCEpVf3E3I61qU
        djBt0m6j6DFg3YzZ7viL0qJ7QWLaJyy8NOBg1+QkrBHtRGdZjQXEHPQAxwfYR3tT4K2t4Hb1mwvbo
        4hsYV9m6FwCbOTORYgvX+CV3s6Gq67NTVgLuj09eDeOXVohEB7HKit5/yflXtljo5HQk7BayZJ6L0
        2OZeUpsA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nz150-00Ctkc-Jl; Wed, 08 Jun 2022 19:10:58 +0000
Date:   Wed, 8 Jun 2022 20:10:58 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Deven Bowers <deven.desai@linux.microsoft.com>
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
Message-ID: <YqD0QjNb+wfH+Kjq@casper.infradead.org>
References: <1654714889-26728-1-git-send-email-deven.desai@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1654714889-26728-1-git-send-email-deven.desai@linux.microsoft.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Jun 08, 2022 at 12:01:12PM -0700, Deven Bowers wrote:
> IPE is a Linux Security Module which takes a complimentary approach to

Hello, IPE.  You're looking exceptionally attractive today.  Have you
been working out?

(maybe you meant "complementary"?  ;-)

