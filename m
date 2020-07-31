Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7685234C54
	for <lists+linux-fscrypt@lfdr.de>; Fri, 31 Jul 2020 22:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728878AbgGaUbr (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 31 Jul 2020 16:31:47 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47430 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726950AbgGaUbr (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 31 Jul 2020 16:31:47 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06VKUTDY004048;
        Fri, 31 Jul 2020 13:31:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=2vuEcdTHglrVOdy4LcWsirYI+YJHF3wFYus3jTG0/PY=;
 b=XQM+CRykzuCLXPmf4pWbSBNJxgje/gieszQ8t1suNStc5t04O6A3uqMVVaSbEe5Gt/3e
 PTVLtyvdn9dMg97FQRYJS8qComJBKFe84S5VG2AnxWg05uDacGCBxqJN6O86eEgDxJ62
 y8rUY3YMNlWVqCRflVgLAvipNquVQQmNLQI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32mn7g9n54-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 31 Jul 2020 13:31:40 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 31 Jul 2020 13:31:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HUa++9IFrQiTSONZmB6n/g2hJEKJrzLbz4q3pdh5zJMi6aYCBdeKQX0FgjpSsgzgfssuBstaDOgA90kAYWPvPri40Q0IA/q4HjTm1Rxv6yciA4Q+PcMmgEadHNKK6NJRTkFuJofGBT3+v58xj6q3r4Ou3X7Q68LniY4XV51xHKAEHmDk5/BunfcLm4Y/UKJX+BE9b/Q/n5PuJoI0sUu0Pj7MyZ4fEAw9LtjYFr2IuofFpqHjtqM2SVaBtUuOMkibusHOSqGOHxLLjAoKAcnXqkKUUE1XlRtPdgQhx39RwH8GhvbY9XexwxNqrJSmXbOo1QuUim/S4mNpb3Ckr794pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2vuEcdTHglrVOdy4LcWsirYI+YJHF3wFYus3jTG0/PY=;
 b=NqbvgTuifa0hKTEayqbdoUVIh8+IRmsDngLRkeraP33mr1VxWCsSatlDAvFAxtVowxTJRdXUc7viavPQCA6K06GUrL7mgfjpQoCcWR/vgL9uiTug1XE5+Rcbi6VJ4WkyDj2XV1Cpo4KSqWfnTb7avKsjP9ge1kGb5m8plMM/43VEHpPftY03uA5s6vLB8w4dvzh4DX8HlTYDLHc1RnDxAZ8HdJE8DBpwGq+XFzkAU4tLlvxsit2pP96Osv9XtWvKxKBWxSpMcD71J5X5/QsOxIjixnsi9gg4n+A8GmdTSAJj6hVwUdlV6a+rqcIJMDjBCbcg6lEYRE6E18a8QIIvRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2vuEcdTHglrVOdy4LcWsirYI+YJHF3wFYus3jTG0/PY=;
 b=UMhUaRsx+hQSiGvInjlPCT7Fj69PxPGqpGqRyYcqRKAFbSJafh011LaREdWP4wJePAP07dUorC1OthPLz7OkNRMtil3tsKoX40/q+6QnmEuzypgozQHhb4pWKWqsCmwzEXwcsWs5Eilwr35y+e0ujt9tFP8wN/vqfW75dhsPp5E=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
Received: from MN2PR15MB3582.namprd15.prod.outlook.com (2603:10b6:208:1b5::23)
 by MN2PR15MB3677.namprd15.prod.outlook.com (2603:10b6:208:183::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Fri, 31 Jul
 2020 20:31:36 +0000
Received: from MN2PR15MB3582.namprd15.prod.outlook.com
 ([fe80::e9ef:ba4c:dd70:b372]) by MN2PR15MB3582.namprd15.prod.outlook.com
 ([fe80::e9ef:ba4c:dd70:b372%5]) with mapi id 15.20.3216.034; Fri, 31 Jul 2020
 20:31:36 +0000
From:   "Chris Mason" <clm@fb.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     <linux-fscrypt@vger.kernel.org>, Jes Sorensen <jsorensen@fb.com>,
        Jes Sorensen <jes.sorensen@gmail.com>, <kernel-team@fb.com>,
        Victor Hsieh <victorhsieh@google.com>
Subject: Re: [fsverity-utils PATCH] Switch to MIT license
Date:   Fri, 31 Jul 2020 16:31:32 -0400
X-Mailer: MailMate (1.13.1r5671)
Message-ID: <97CF68DA-3272-41D8-ACB2-544704C343BF@fb.com>
In-Reply-To: <20200731191156.22602-1-ebiggers@kernel.org>
References: <20200731191156.22602-1-ebiggers@kernel.org>
Content-Type: text/plain; format=flowed
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR01CA0021.prod.exchangelabs.com (2603:10b6:208:10c::34)
 To MN2PR15MB3582.namprd15.prod.outlook.com (2603:10b6:208:1b5::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [100.109.94.142] (2620:10d:c091:480::1:8f57) by MN2PR01CA0021.prod.exchangelabs.com (2603:10b6:208:10c::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.18 via Frontend Transport; Fri, 31 Jul 2020 20:31:34 +0000
X-Mailer: MailMate (1.13.1r5671)
X-Originating-IP: [2620:10d:c091:480::1:8f57]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8f8b0944-aaf9-47c1-1f55-08d83590b7da
X-MS-TrafficTypeDiagnostic: MN2PR15MB3677:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR15MB36773B39680EFD00BB660A29D34E0@MN2PR15MB3677.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1051;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /Jy9s+TugkopMur1GBoJVA0szqX7wJFNz+Bnojd99CT8oWXTN5t7d3+CYiJt2b+Ln7/oX6nrCU7wIrmkzWtKhWZ6S62kDzIJRbwRZJA4w/8N2vV7aRprK0OEinreYcbYsEFLMu6fxcgy3Katfkmtzl4JxE+XSBi1Yx6IJiG535F02CVFFc9QWieaqGDT9BPCz1ISY3SNmoQLPcvolYUsfVYmtHMoN1OuFISuvLRKtrndVDo2Bi+5lrfKoIsJAS8Y85P7y9gAX2aJo44bZA8+unhGvFzGx0dkW9qqSUiT6gLco7FMdCPZsL7nDxFxlG2dtHunNwyY+YfkRKUgxxGNzHRFJE66nMCxOJzacMOoeifOagvJE1F0Le6bHZG7wnw6UKZdN5x+DyPjO19s5wGBAhFFsy2F6f4zBoGYSKaSrPXjc7Q3W/qCQpC4/irvxUdUmvXMGBiukzNxw6npxM7HCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR15MB3582.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(346002)(376002)(396003)(39860400002)(366004)(956004)(6916009)(8936002)(33656002)(6486002)(4326008)(2906002)(8676002)(2616005)(316002)(966005)(53546011)(54906003)(5660300002)(16526019)(478600001)(186003)(52116002)(36756003)(66946007)(66476007)(66556008)(4744005)(86362001)(78286006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: xChhZMSc559byOU15ldRiN1jp5QtulrvE0RlWM4fMlcEr8nEa4EQPnQGHXnPw/fsTjSk65BAVRMCXZx0PfAz/AeDCqzbE+F9WkwZAooOCXGSCepj+JjKQVnPjvBrf0zO+U0QVQutOhLDnAscf8fzOnHc6cssvzblg1WDBlF18hJ6KH2OHgMHWjeFyw+9JaXuMrT2eJqOSJh+zmxnCi0kzU4R9sgQG0XxUbmaC1gnEUQh5eIdbqYh2b17jlfHAVArznxCjiY4YfdsjrkaC/Ecnj+45omuJArtZcGFmH7LXXQcT5oubfG5iPINIU3ynStVnKijIyT7s6xZPHb5Hb97kh1W4/6UR33zqM2uSjoATXt3KjvtxE7Dhx7b7PHmCLvx9zSEeAT3ObAKG2oTGEr7E9rnF315xjpRm+Binf5KrkWgYmWQ955gIKNpknWjG9wt8jwK58+n+Hev+Lmou6nj1CoW78PmxVs4w6+AK9372r2v29zqaFwAWtmVOMgURTx5mXVSvv5JNjErU7icRliDL8WRvhsw5HXutJG641VGXD8h3sPlT6NxwMqaxDfVWmLn+NqETBE3izblm30RzeQHoIbtidduj+rzFIzh4zLREl/+EysJgB+5Gbs0Muuj0dJ1KQT20IHavVKRN4zCkh+H/wOly0PWZHrVcwYgAnY6197cb6O1mtJBFrPwpT8i15nb
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f8b0944-aaf9-47c1-1f55-08d83590b7da
X-MS-Exchange-CrossTenant-AuthSource: MN2PR15MB3582.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2020 20:31:36.0147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NinVrKNBmdJA+NhXXkb348c3iQEqRxdKt3FumWWF7MoWegHNGBvb06Gj4L/Hs6k/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3677
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-31_08:2020-07-31,2020-07-31 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 adultscore=0
 impostorscore=0 mlxlogscore=978 mlxscore=0 priorityscore=1501
 clxscore=1011 suspectscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007310146
X-FB-Internal: deliver
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org



On 31 Jul 2020, at 15:11, Eric Biggers wrote:

> From: Eric Biggers <ebiggers@google.com>
>
> This allows libfsverity to be used by software with other common
> licenses, e.g. LGPL, MIT, BSD, and Apache 2.0.  It also avoids the
> incompatibility that some people perceive between OpenSSL and the GPL.
>
> See discussion at
> https://lkml.kernel.org/linux-fscrypt/20200211000037.189180-1-Jes.Soren=
sen@gmail.com/T/#u
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Chris Mason <clm@fb.com> # FB copyrighted material
