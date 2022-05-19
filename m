Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE5CE52D0FB
	for <lists+linux-fscrypt@lfdr.de>; Thu, 19 May 2022 12:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237099AbiESK6z (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 19 May 2022 06:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237160AbiESK6q (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 19 May 2022 06:58:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 073F0B227A
        for <linux-fscrypt@vger.kernel.org>; Thu, 19 May 2022 03:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652957921;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l4wUUc7LmhfljuyY0/HuRTpgr8VwARyFTE0ZQnyAXeU=;
        b=MkuV/IMadFUfHk97qccvxG+zOsiEtqnJ0RWby4ZpzjUP7uMHdZ/QQjWhJwhCQivJMjrK53
        a2MwxlJmA174ugKARAoByddVLqI9MaH4VjuyWKP7A8LWNUKTjNiz0aBoOsV9cM7X48Gxpd
        yGjzs1Gm7WsMMEtvTL0WEdCwUYgWIjk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-397-v_nr2-cqP2Guf3nFSjys4Q-1; Thu, 19 May 2022 06:58:38 -0400
X-MC-Unique: v_nr2-cqP2Guf3nFSjys4Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9AADA802A5B;
        Thu, 19 May 2022 10:58:37 +0000 (UTC)
Received: from fedora (unknown [10.40.193.239])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C9D6B2026D6A;
        Thu, 19 May 2022 10:58:36 +0000 (UTC)
Date:   Thu, 19 May 2022 12:58:34 +0200
From:   Lukas Czerner <lczerner@redhat.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-ext4@vger.kernel.org
Subject: Re: [xfstests PATCH 0/2] update test_dummy_encryption testing in
 ext4/053
Message-ID: <20220519105834.4pypxwawqwjmlcmx@fedora>
References: <20220501051928.540278-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220501051928.540278-1-ebiggers@kernel.org>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sat, Apr 30, 2022 at 10:19:26PM -0700, Eric Biggers wrote:
> This series updates the testing of the test_dummy_encryption mount
> option in ext4/053.
> 
> The first patch will be needed for the test to pass if the kernel patch
> "ext4: only allow test_dummy_encryption when supported"
> (https://lore.kernel.org/r/20220501050857.538984-2-ebiggers@kernel.org)
> is applied.
> 
> The second patch starts testing a case that previously wasn't tested.
> It reproduces a bug that was introduced in the v5.17 kernel and will
> be fixed by the kernel patch
> "ext4: fix up test_dummy_encryption handling for new mount API"
> (https://lore.kernel.org/r/20220501050857.538984-6-ebiggers@kernel.org).
> 
> This applies on top of my recent patch
> "ext4/053: fix the rejected mount option testing"
> (https://lore.kernel.org/r/20220430192130.131842-1-ebiggers@kernel.org).
> 
> Eric Biggers (2):
>   ext4/053: update the test_dummy_encryption tests
>   ext4/053: test changing test_dummy_encryption on remount
> 
>  tests/ext4/053 | 38 ++++++++++++++++++++++++--------------
>  1 file changed, 24 insertions(+), 14 deletions(-)
> 
> -- 
> 2.36.0

The series looks good to me, you can add

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

