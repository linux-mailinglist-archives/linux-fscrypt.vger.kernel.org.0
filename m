Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62D937E1723
	for <lists+linux-fscrypt@lfdr.de>; Sun,  5 Nov 2023 23:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbjKEWAP (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 5 Nov 2023 17:00:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbjKEWAO (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 5 Nov 2023 17:00:14 -0500
X-Greylist: delayed 5195 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 05 Nov 2023 14:00:11 PST
Received: from SMTP-HCRC-200.brggroup.vn (mail.hcrc.vn [42.112.212.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 955AFE6
        for <linux-fscrypt@vger.kernel.org>; Sun,  5 Nov 2023 14:00:11 -0800 (PST)
Received: from SMTP-HCRC-200.brggroup.vn (localhost [127.0.0.1])
        by SMTP-HCRC-200.brggroup.vn (SMTP-CTTV) with ESMTP id 3D08819586;
        Mon,  6 Nov 2023 01:58:00 +0700 (+07)
Received: from zimbra.hcrc.vn (unknown [192.168.200.66])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by SMTP-HCRC-200.brggroup.vn (SMTP-CTTV) with ESMTPS id 35FA71951C;
        Mon,  6 Nov 2023 01:58:00 +0700 (+07)
Received: from localhost (localhost [127.0.0.1])
        by zimbra.hcrc.vn (Postfix) with ESMTP id BF3CC1B8204A;
        Mon,  6 Nov 2023 01:58:01 +0700 (+07)
Received: from zimbra.hcrc.vn ([127.0.0.1])
        by localhost (zimbra.hcrc.vn [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id m95m__PDOVCC; Mon,  6 Nov 2023 01:58:01 +0700 (+07)
Received: from localhost (localhost [127.0.0.1])
        by zimbra.hcrc.vn (Postfix) with ESMTP id 8C33B1B8253C;
        Mon,  6 Nov 2023 01:58:01 +0700 (+07)
DKIM-Filter: OpenDKIM Filter v2.10.3 zimbra.hcrc.vn 8C33B1B8253C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hcrc.vn;
        s=64D43D38-C7D6-11ED-8EFE-0027945F1BFA; t=1699210681;
        bh=WOZURJ77pkiMUL2pPLC14ifVPRvyTQIBEQmxuN1ezAA=;
        h=MIME-Version:To:From:Date:Message-Id;
        b=CTtF2xAFcf5uE5vo8KNBmTe/1Mv+XDJ71NpYsd8O8CzYFp6GyGPwU4KygA3OyAmqO
         woCbqHMHZL3RHG7dk9wtuhkpVXX/NpIWf4sbDlvPLs0yUfnB9rII2UeOWPfl7X2RQo
         81US7eEn8N1qp3OILaTRaFdEF6Tdhz7DpQvJJCWQz+f0QgyXT+L93MsLFe9RFLaa6J
         HwexTJhgJeBzu0HILONcAKizuDjW2xVq+OsbAbRcE8Sl/58NPqA9y7p7ekK+9+8sZl
         o66RWP911Qihyxy+1fOzs9k4KMF21trs5K7AMe0NJL5NwM6C08IHbETi/R6X22h/Tk
         FRUYIyMrSDlaQ==
X-Virus-Scanned: amavisd-new at hcrc.vn
Received: from zimbra.hcrc.vn ([127.0.0.1])
        by localhost (zimbra.hcrc.vn [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id l7PFE2No8KVI; Mon,  6 Nov 2023 01:58:01 +0700 (+07)
Received: from [192.168.1.152] (unknown [51.179.100.52])
        by zimbra.hcrc.vn (Postfix) with ESMTPSA id 293C51B8204A;
        Mon,  6 Nov 2023 01:57:54 +0700 (+07)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: =?utf-8?b?4oKsIDEwMC4wMDAuMDAwPw==?=
To:     Recipients <ch.31hamnghi@hcrc.vn>
From:   ch.31hamnghi@hcrc.vn
Date:   Sun, 05 Nov 2023 19:57:40 +0100
Reply-To: joliushk@gmail.com
Message-Id: <20231105185755.293C51B8204A@zimbra.hcrc.vn>
X-Spam-Status: No, score=2.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FORGED_REPLYTO,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Goededag,
Ik ben mevrouw Joanna Liu en een medewerker van Citi Bank Hong Kong.
Kan ik =E2=82=AC 100.000.000 aan u overmaken? Kan ik je vertrouwen


Ik wacht op jullie reacties
Met vriendelijke groeten
mevrouw Joanna Liu

