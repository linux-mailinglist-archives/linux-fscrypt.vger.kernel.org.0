Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE113687109
	for <lists+linux-fscrypt@lfdr.de>; Wed,  1 Feb 2023 23:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbjBAWiz (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 1 Feb 2023 17:38:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjBAWiz (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 1 Feb 2023 17:38:55 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 271432448A;
        Wed,  1 Feb 2023 14:38:54 -0800 (PST)
Received: by linux.microsoft.com (Postfix, from userid 1052)
        id CF5C720B7102; Wed,  1 Feb 2023 14:38:53 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com CF5C720B7102
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1675291133;
        bh=X6Z3SyRKiX/3YhcTna3d9v6sceTUrdxFhxD/bKHpZ4c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IxslADlFEYQZMJvHUA7pp3pudbEUh76Uyb4kg2JKcyhs7cNwjw9/QAXx3RssXIDGE
         sQkJ1U1gvFt9hjJketeFSBeDyWH2dlcl18UjTTX/hqSc2PuMPCQkTvcXaGBW505YW0
         uZ1oGYebVMeBMRV1DwpSMwilw7Lq854MJzQEdPrg=
Date:   Wed, 1 Feb 2023 14:38:53 -0800
From:   Fan Wu <wufan@linux.microsoft.com>
To:     Roberto Sassu <roberto.sassu@huaweicloud.com>
Cc:     corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org,
        serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
        axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
        eparis@redhat.com, paul@paul-moore.com, linux-doc@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, linux-audit@redhat.com,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org,
        Deven Bowers <deven.desai@linux.microsoft.com>
Subject: Re: [RFC PATCH v9 02/16] ipe: add policy parser
Message-ID: <20230201223853.GA9075@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-3-git-send-email-wufan@linux.microsoft.com>
 <dd7df8bc5b69a6745bdcf030a4e0690e3e067ff2.camel@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd7df8bc5b69a6745bdcf030a4e0690e3e067ff2.camel@huaweicloud.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Jan 31, 2023 at 11:53:27AM +0100, Roberto Sassu wrote:
> On Mon, 2023-01-30 at 14:57 -0800, Fan Wu wrote:
> > From: Deven Bowers <deven.desai@linux.microsoft.com>
> 
> Uhm, memory leak? Also below. I suggest to use kmemleak.
> 
> Roberto
> 
Nice catch and thanks for the suggestion, I used kmemleak
and detected several incomplete cleanup. Will be fixed in
the next version.
-Fan
