Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C64A42CA94
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 Oct 2021 22:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbhJMUFP (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 13 Oct 2021 16:05:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44659 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230474AbhJMUFO (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 13 Oct 2021 16:05:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634155390;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hhdJcjen3v6j5NvKxp+J2wwagi0CnajVx1UoxFM+giI=;
        b=LESRNA9liFYSz7JPBzURzFHLqMbAbSCMX1fZqWKL6GSeKHwvgKW5it5vxO2u4q6UvtVCri
        JMoaDXfJcGeVdl3+QRj+CyKjnfqOP+hkej5Sl96UI7xGTw5McDvMcDyWObrkIgtUobLJiU
        X6U82FH4/QlkZbIEHQQDRZHLSuVueiI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-118-2vNBfazkO4WqK0T5L2x5ww-1; Wed, 13 Oct 2021 16:03:07 -0400
X-MC-Unique: 2vNBfazkO4WqK0T5L2x5ww-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D26091006AB1;
        Wed, 13 Oct 2021 20:03:04 +0000 (UTC)
Received: from x2.localnet (unknown [10.22.33.236])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 330135BAFB;
        Wed, 13 Oct 2021 20:02:32 +0000 (UTC)
From:   Steve Grubb <sgrubb@redhat.com>
To:     corbet@lwn.net, axboe@kernel.dk, agk@redhat.com,
        snitzer@redhat.com, ebiggers@kernel.org, tytso@mit.edu,
        paul@paul-moore.com, eparis@redhat.com, jmorris@namei.org,
        serge@hallyn.com, linux-audit@redhat.com
Cc:     linux-security-module@vger.kernel.org, linux-doc@vger.kernel.org,
        jannh@google.com, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, linux-audit@redhat.com,
        deven.desai@linux.microsoft.com
Subject: Re: [RFC PATCH v7 07/16] ipe: add auditing support
Date:   Wed, 13 Oct 2021 16:02:30 -0400
Message-ID: <2159283.iZASKD2KPV@x2>
Organization: Red Hat
In-Reply-To: <1634151995-16266-8-git-send-email-deven.desai@linux.microsoft.com>
References: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com> <1634151995-16266-8-git-send-email-deven.desai@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hello,

On Wednesday, October 13, 2021 3:06:26 PM EDT deven.desai@linux.microsoft.com 
wrote:
> Users of IPE require a way to identify when and why an operation fails,
> allowing them to both respond to violations of policy and be notified
> of potentially malicious actions on their systens with respect to IPE
> itself.

Would you mind sending examples of audit events so that we can see what the 
end result is? Some people add them to the commit text. But we still need to 
see what they look like.

Thanks,
-Steve


